Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:56188 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbcAJWEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 17:04:43 -0500
Date: Sun, 10 Jan 2016 23:04:37 +0100
From: Ernst Martin Witte <emw-linux-media-2016@nocabal.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [REGRESSION/bisected] kernel panic after "rmmod cx23885" by
 "si2157: implement signal strength stats"
Message-ID: <20160110220437.GA2616@titiwu.nocabal.de>
Reply-To: emw-linux-media-2016@nocabal.de
References: <20160108121852.GA29971@[192.168.115.1]>
 <20160109214237.GA25076@titiwu.nocabal.de>
 <5691D351.2030005@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5691D351.2030005@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti!

Thx for  your quick answer. Since  I'm not familiar with  linux kernel
driver  internals,  may  I  ask  few  questions  in  order  to  better
understand the  intended use  of ..._delayed_work and  the interaction
between drivers like the cx23885 and the tuner modules?

- Is si2157_sleep not related to "suspended" system power state but to
  an "unused" state of the tuner physical device?

- Which  mechanism  should  call  si2157_sleep when  e.g.  cx23885  is
  rmmod'ed?

- What  I  understood   so  far  is  that  we  should   not  need  the
  cance_delayed_work_sync in ..._remove  because ..._sleep should have
  been called before.  Why is  such a cancel_delayed_work call already
  in  the  kernel  in  rtl2832_remove although  this  module  has  the
  separate cancel_delayed_work call in rtl23832_sleep?

- If si2157_sleep  was not called and  the device is considered  to be
  still   active,  which   mechanism  should   prevent  the   call  of
  si2157_remove or the unloading of module cx23885?

- Is it correct that rmmod cx23885  is legitime if none of its devices
  is in use by any app and if those "links" between si2157 and cx23885
  are  shut down  correctly?  ...   and  should only  be prevented  if
  something goes wrong with shutting down those "links"?

- Is the  interpretation correct  that si2157_remove should  be called
  when the  driver/module si2157  is unloaded?  If yes  - how  does it
  happen that it gets called when only an rmmod cx23885 is done?

- What    is   the    intended    call   sequence    of   all    those
  sleep/remove/... callbacks when

  a) an applications closes the device (but driver remains loaded, but
     presumingly inactive)

  b) the  one or other  module is  rmmod'ed (for me  personally mainly
     cx23885)

...  you might  see that  for me  it's mainly  unclear how  si2157 and
cx23885 are linked in terms of callbacks.

Is there anything  I could try (adding debug statements,  etc.) / test
in order to get more insight what's going wrong?

BR and many thanks for your help,
  Martin


On 10.01.2016 05:43, Antti Palosaari wrote:
> Hello
> Those timers are activated on frontend init() ja de-activated on sleep().
> Removing active driver does not sound good and IMHO it should not be even
> possible. I think it should be find out why it is possible to remove whole
> driver before it is put to sleep().
> 
> Antti
> 
> 
> On 01/09/2016 11:42 PM, Ernst Martin Witte wrote:
> >Hi again,
> >
> >seems  that the  cause  for the  kernel  panic is  a  missing call  to
> >cancel_delayed_work_sync in  si2157_remove before  the call  to kfree.
> >After adding cancel_delayed_work_sync(&dev->stat_work), rmmod does not
> >trigger the kernel panic any more.
> >
> >However, very similar issues could be identified also in other modules:
> >
> >    ts2020
> >    af9013
> >    af9033
> >    rtl2830
> >
> >when looking in drivers/media/tuners and drivers/media/dvb-frontends.
> >
> >Therefore,  the submitted  patch  set contains  fixes  also for  those
> >modules. The submitted patch set is:
> >
> >    [PATCH 0/5] [media] cancel_delayed_work_sync before device removal / kfree
> >
> >I hope these patches completely fix the issue and are ok for inclusion
> >in the kernel.
> >
> >BR and thx,
> >    Martin
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> -- 
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
