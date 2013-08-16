Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:57148 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3HPX70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 19:59:26 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Fri, 16 Aug 2013 21:00:24 +0200
To: linux-media@vger.kernel.org
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
	Hans Petter Selasky <hans.petter.selasky@bitfrost.no>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] media: rc: rdev->open or rdev->close can be NULL
Message-ID: <20130816190024.GA19920@triton8.kn-bremen.de>
References: <51A10BD5.1050107@bitfrost.no>
 <zarafa.520e5885.7648.5a3ce2f304daebfb@mail.lockless.no>
 <520E5A98.9060004@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E5A98.9060004@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 16, 2013 at 06:00:08PM +0100, Srinivas KANDAGATLA wrote:
> + adding Mauro Chehab
> On 16/08/13 17:51, Hans Petter Selasky wrote:
> > Hi Jurgen,
> > 
> > I think this is something broken at the Linux side or I have sources out of sync.
> > You should just ignore the NULL function pointer, hence the technisat driver does not have these callbacks. 
> 
> I agree, I was under the impression that open/close are mandatory.
> 
> Can you please send a patch to fix this to linux-media@vger.kernel.org.
> 
> Thanks,
> srini
> 
At least technisat-usb2.c doesn't set these...

Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -707,7 +707,7 @@ int rc_open(struct rc_dev *rdev)
 		return -EINVAL;
 
 	mutex_lock(&rdev->lock);
-	if (!rdev->users++)
+	if (!rdev->users++ && rdev->open != NULL)
 		rval = rdev->open(rdev);
 
 	if (rval)
@@ -731,7 +731,7 @@ void rc_close(struct rc_dev *rdev)
 	if (rdev) {
 		mutex_lock(&rdev->lock);
 
-		 if (!--rdev->users)
+		 if (!--rdev->users && rdev->close != NULL)
 			rdev->close(rdev);
 
 		mutex_unlock(&rdev->lock);
