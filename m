Return-path: <linux-media-owner@vger.kernel.org>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:38168 "EHLO
	bordeaux.papayaltd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2FMQT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 12:19:57 -0400
Subject: Re: Hauppauge WinTV Nova S Plus Composite IN
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andre <linux-media@dinkum.org.uk>
In-Reply-To: <CAPz3gmke-ASEXzhcqn+9R-5f10hrux3cqS1NAQ6VYmH3JSjb-Q@mail.gmail.com>
Date: Wed, 13 Jun 2012 17:19:56 +0100
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <76B80933-CE9A-4886-B4EB-22C26CAEC8E8@dinkum.org.uk>
References: <CAPz3gmnaPdm1V6GyPB8wPv5WCcg_pJ4HctsQiqROLanbLA=amA@mail.gmail.com> <BE0BB692-35BF-42C3-B2F1-5AC9AB053321@dinkum.org.uk> <CAPz3gmke-ASEXzhcqn+9R-5f10hrux3cqS1NAQ6VYmH3JSjb-Q@mail.gmail.com>
To: shacky <shacky83@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 13 Jun 2012, at 15:56, shacky wrote:

>> mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd:tsaf   -vf scale=720:576,harddup -srate 48000 -af lavcresample=48000   -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=8000:keyint=15:vstrict=0:acodec=ac3:abitrate=192:aspect=4/3 -ofps 25   -o johntest1.mpg tv:// -tv input=1:norm=PAL-BG:amode=1:alsa=1:adevice=hw.2,0:forceaudio:immediatemode=0:volume=100
> 
> Thank you very much Andre! It works!
> 
> I only have a problem with the audio quality: it is distorted
> especially on the high frequencies.
> Do you have any idea?

Only to play with the volume= parameter, I'm sure you tried that, maybe there are some audio controls but I haven't found them. The VCR tapes I have to transfer have very quiet and muffled audio, old home videos so I thought the audio sounded ok.

I will be doing some recordings with this in a week or so after a business trip so maybe I'll find out something more then.

There must be someone on this list who knows a great deal more about the mixers and filters available.

Andre


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

