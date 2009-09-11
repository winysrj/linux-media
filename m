Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:58576 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZIKNqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 09:46:07 -0400
From: iceberg <strakh@ispras.ru>
To: Jonathan Corbet <corbet@lwn.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
Date: Fri, 11 Sep 2009 17:47:39 +0000
References: <200909101837.34472.strakh@ispras.ru> <20090910093003.194c300f@bike.lwn.net>
In-Reply-To: <20090910093003.194c300f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909111747.40238.strakh@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 September 2009 15:30:03 you wrote:

	Incorrect patch. See path starting with "if (cam->sensor == null) {" in line 
1960. In this case we goto out_smbs and try mutex_unlock on unlocking mutex.

> On Thu, 10 Sep 2009 18:37:34 +0000
>
> iceberg <strakh@ispras.ru> wrote:
> > In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe:
> > Mutex must be unlocked before exit
> > 	1. On paths starting with mutex lock in line 1912, then continuing in
> > lines: 1929, 1936 (goto unreg) and 1940 (goto iounmap) .
> > 	2. On path starting in line 1971 mutex lock, and then continuing in line
> > 1978 (goto out_smbus) mutex.
>
> That's a definite bug, but I hate all those unlocks in the error
> branches.  As it happens, we don't really need the mutex until the
> device has been exposed to the rest of the kernel, so I propose the
> following as a better patch.
>
> Thanks for pointing this out,
>
> jon
>
> ---
> Fix a mutex leak
>
> Certain error exits from cafe_pci_probe() can leave the camera mutex
> locked.  For much of the time, we didn't need the mutex anyway; take it out
> and add an unlock in the path where it is needed.
>
> Reported-by: Alexander Strakh <strakh@ispras.ru>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/cafe_ccic.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/cafe_ccic.c
> b/drivers/media/video/cafe_ccic.c index c4d181d..0f62b5e 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -1909,7 +1909,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  		goto out_free;
>
>  	mutex_init(&cam->s_mutex);
> -	mutex_lock(&cam->s_mutex);
>  	spin_lock_init(&cam->dev_lock);
>  	cam->state = S_NOTREADY;
>  	cafe_set_config_needed(cam, 1);
> @@ -1949,7 +1948,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  	 * because the sensor could attach in this call chain, leading to
>  	 * unsightly deadlocks.
>  	 */
> -	mutex_unlock(&cam->s_mutex);  /* attach can deadlock */
>  	ret = cafe_smbus_setup(cam);
>  	if (ret)
>  		goto out_freeirq;
> @@ -1991,6 +1989,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  	return 0;
>
>  out_smbus:
> +	mutex_unlock(&cam->s_mutex);
>  	cafe_smbus_shutdown(cam);
>  out_freeirq:
>  	cafe_ctlr_power_down(cam);



