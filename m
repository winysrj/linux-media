Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46835 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZAKRLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 12:11:10 -0500
Received: by bwz14 with SMTP id 14so31139338bwz.13
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2009 09:11:08 -0800 (PST)
Date: Sun, 11 Jan 2009 18:10:54 +0100
To: Mika Laitio <lamikr@pilppa.org>
Cc: linux-media@vger.kernel.org
Subject: Re: latest S2API segfaults for cx88 (hvr-1300 and hvr-4000)
Message-ID: <20090111171054.GA3489@gmail.com>
References: <Pine.LNX.4.64.0901102027360.4390@shogun.pilppa.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0901102027360.4390@shogun.pilppa.org>
From: Gregoire Favre <gregoire.favre@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 10, 2009 at 08:45:50PM +0200, Mika Laitio wrote:

Hello,

I have compiled 2.6.28 with the included DVB modules and with that
version all my cards do tune !!!

I just forgot to add CAN_DO_2ND... flag to the modules so I can't test
DVB-S2 right now, and of course the current v4l-dvb's hg source just
segfault like you repported here.

Is there something we can do in order to fix this hudge regression in
the v4l-dvb's hg ?

> I checked out and build today the latest vl4-dvb drivers
> (changeset:   10210:985ecd81d993) against the 2.6.27.1 kernel
> and the drivers segfaults on load for me.
>
> Attached is the segfault + /proc/interrupts output.
>
> I have in my system both the hvr-1300 and hvr-4000.
> Last driver version that I have tested to work is from 2008-12-31.
> (changeset:   10165:3e5f56413191 which added the FE_CAN_2G_MODULATION flag)
>
> With this older version of driver I am able to tune to dvb-t (from 
> hvr-1300) and dvb-s/s2 (from hvr-4000) with command line tools like scan, 
> szap,szap2 or older vdr-1.6.0 which is not aware from s2api and uses thus 
> older dvb driver api.
>
> But even with that version (2008-12-31) version of driver there is some 
> problem, because unlike the hvr-3200 users, I am not able to change dvb-s 
> or dvb-s2 channels with vdr-1.7.3. Changing of dvb-t channels works ok.
> If I have earlier szapped the correct dvb-s/s2 channel by using the 
> szap/szap-s2 and then quitted it with ctrl-c and started vdr-1.7.3, I am 
> able to watch that S/S2 channels, but any attempt to switch for some other 
> s/s2 channels will fail. Unlike Gregoire Favre who is not able to tune any 
> S/S2 channels even from command line, I do not have diseqs installed in my 
> system. (hvr-4000 is connected directly via wire to lnb)
-- 
Grégoire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
