Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp113.rog.mail.re2.yahoo.com ([68.142.225.229]:30075 "HELO
	smtp113.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752001AbZBOXpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 18:45:18 -0500
Message-ID: <4998A90D.3050403@rogers.com>
Date: Sun, 15 Feb 2009 18:45:17 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] A dvb-core code problem
References: <4994E795.6030700@telegentsystems.com>
In-Reply-To: <4994E795.6030700@telegentsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zhang Xiaobing wrote:
> I found a code problem in dvb-core when I was debugging with my dvb
> driver.
>
> The code in dvb_dvr_release() file dmxdev.c
> /* TODO */
>     dvbdev->users--;
>     if(*dvbdev->users== -1* && dmxdev->exit==1) {
>         fops_put(file->f_op);
>         file->f_op = NULL;
>         mutex_unlock(&dmxdev->mutex);
>
> "dvbdev->users== -1" should be changed to "dvbdev->users== 1",
> otherwise driver may block forever in dvb_dmxdev_release() where a
> wakeup condition is "dvbdev->users== 1".
>
> Here is the code in dvb_dmxdev_release().
>
> if (dmxdev->dvr_dvbdev->users > 1) {
>         wait_event(dmxdev->dvr_dvbdev->wait_queue,
>                 *dmxdev->dvr_dvbdev->users==1*);
> }
>
> I hope it is right to post this message here.

Hi Zhang,  could you post a patch to the linux-media mail list; for
general info see here:
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches


