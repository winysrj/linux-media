Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53568 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZFWSiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 14:38:46 -0400
Received: by ewy6 with SMTP id 6so422485ewy.37
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 11:38:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d5f8630906220351w7c6e233fg8aea5d72f51466e9@mail.gmail.com>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
	 <1245199671.7551.6.camel@pc07.localdom.local>
	 <4d5f8630906182120j6f49cd85sd459c14d05c8b722@mail.gmail.com>
	 <4d5f8630906182203h739363aeu85996062f282e106@mail.gmail.com>
	 <6ab2c27e0906190110p196f709fp2aefbfc0063f334c@mail.gmail.com>
	 <4d5f8630906190242w1af2ad66u79e0f96ccf613afe@mail.gmail.com>
	 <1245430287.3985.5.camel@pc07.localdom.local>
	 <37219a840906191228t7222e21dyc2c221bb5d9e22bb@mail.gmail.com>
	 <4d5f8630906220351w7c6e233fg8aea5d72f51466e9@mail.gmail.com>
Date: Tue, 23 Jun 2009 14:38:48 -0400
Message-ID: <37219a840906231138g59a2a749ucd4e0a92be906430@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S
From: Michael Krufky <mkrufky@kernellabs.com>
To: James Moschou <james.moschou@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>, paul10@planar.id.au,
	braddo@tranceaddict.net, Sander Pientka <cumulus0007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(apologies if you've received this email twice -- something is strange
with my kernellabs.com email settings -- I will look into this soon)

On Mon, Jun 22, 2009 at 6:51 AM, James Moschou<james.moschou@gmail.com> wrote:
> Using dtv1000s tree revision 21a03349f7f9 and a blank modprobe.conf
>
> I can tune to channels but never all of them in the single run of w_scan.
> Every time I run w_scan it's different channels that say 'filter timeout'.

James,

Unfortunately, I can't say that a driver bug is the cause of your
inconsistency -- perhaps you can aim your antennae a bit better, or
find some other cause of interference.  Bad cabling?

Lets say that you have your channels.conf all set up and ready -- once
you found all your services, do you have trouble keeping a stream?

Regards,

Mike
