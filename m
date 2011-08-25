Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm16-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.176]:43262 "HELO
	nm16-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751120Ab1HYX1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 19:27:30 -0400
Message-ID: <1314314849.52943.YahooMailClassic@web121708.mail.ne1.yahoo.com>
Date: Thu, 25 Aug 2011 16:27:29 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Is DVB ioctl FE_SET_FRONTEND broken?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As far as I understand it, the FE_SET_FRONTEND ioctl is supposed to tell a DVB device to tune itself, and will send a poll() event when it completes. The "frequency" parameter of this event will be the frequency of the newly tuned channel, or 0 if tuning failed.

http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION00328000000000000000

I have now tested with 2 different DVB adapters, and I don't think the 3.0.x kernel still behaves like this. A study of the dvb-core/dvb_frontend.c file reveals the following code:

In the dvb_frontend_ioctl_legacy() function,

    switch(cmd) {

    ...

    case FE_SET_FRONTEND: {

        ...

        fepriv->state = FESTATE_RETUNE;

        /* Request the search algorithm to search */
        fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;

        dvb_frontend_wakeup(fe);
        dvb_frontend_add_event(fe, 0);   // <--- HERE!!!!
        fepriv->status = 0;
        err = 0;
        break;
    }

So basically, the ioctl always sends an event immediately and does not wait for the tuning to happen first. Presumably, the device still tunes in the background and writes the frequency into the frontend's private structure so that a second FE_SET_FRONTEND ioctl succeeds. But this is not the documented behaviour.

The bug is visible when you try to use the device for the very first time. I tested by unloading / reloading the kernel modules, launching xine and then pressing its DVB button. This *always* fails the first time, for the reason described above, and works every time after that.

Cheers,
Chris

