Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.44]:25903 "HELO
	nm4-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751433Ab1HZLbt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 07:31:49 -0400
Message-ID: <1314358307.50448.YahooMailClassic@web121706.mail.ne1.yahoo.com>
Date: Fri, 26 Aug 2011 04:31:47 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Is DVB ioctl FE_SET_FRONTEND broken?
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E576C3B.9070204@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 26/8/11, Andreas Oberritter <obi@linuxtv.org> wrote:
> I first thought that you were talking about a
> regression in Linux 3.0.x.

Heh, yes and no. I am talking about a regression that I am definitely seeing in 3.0.x. However, I cannot say which kernel the problem first appeared in.

> This initial event with status=0 exists since 2002. It's
> used to notify a new tuning operation to the event listener.
> 
> http://www.linuxtv.org/cgi-bin/viewvc.cgi/DVB/driver/dvb_frontend.c?revision=1.6.2.30&view=markup

OK, that's different. I've only noticed this regression because xine has started having trouble using a brand new DVB adapter. Debugging the problem has shown that the first event received after a FE_SET_FRONTEND ioctl() has frequency == 0, which is considered an error.

Reading the documentation for FE_SET_FRONTEND lead me to believe that it would send only a single event once tuning had completed, which is not what the code does.
 
> It's not my code and my patch doesn't create any new event.

Those patches don't, no. I was assuming that you were patching code that you had patched earlier. My bad, it seems.

> Your example code can't work. You need to call FE_GET_EVENT
> or FE_READ_STATUS.

And that's why I only called it "pseudocode" :-).
 
> > So I'm going to say "No", your patches don't restore the old behaviour.
> 
> Yes. The patch is restoring a different old behaviour. The
> behaviour you're referring to has never been in the kernel. ;-)

Yikes! Documentation bug, anyone?

Cheers,
Chris

