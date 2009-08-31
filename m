Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:32905 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZHaOJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 10:09:57 -0400
Received: by bwz19 with SMTP id 19so2791707bwz.37
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 07:09:58 -0700 (PDT)
Message-ID: <4A9BD9CB.6090601@gmail.com>
Date: Tue, 01 Sep 2009 00:10:19 +1000
From: jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: hauppauge wintv hvr 2200 and transport stream
References: <COL0-DAV71608B4BDC4C3B032E628B2F20@phx.gbl>
In-Reply-To: <COL0-DAV71608B4BDC4C3B032E628B2F20@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This card does: d+d _or_ d+a _or_ a+d _or_ a+a.... Where d = DVB-T & a = 
PAL analogue transmission.

I believe Steve Toth has gotten dual DVB-T (d+d) to work on this card:  
http://www.kernellabs.com

I think all of those players you mention will playback the the TS stream 
once its dumped on your harddisk as its being dumped.
Provided you have the right codecs/libraries in place, which most modern 
Linux distros already take care of.

Cheers,
Jed

Marco Berizzi wrote:
> Hello everybody.
> I'm evaluating a dvb-t card for linux.
> I would like to know if with the above
> card is possible to save the entire mpeg
> transport stream.
> Also I don't unstand what does mean 'dual
> tuners'. Can I watch two different dvb-t
> channel? Or only one analog and one dvb-t?
> Or 2 dvb-t plus 2 analog?
> Any experience with this device?
>
> PS: Is possible to see with xine/vlc/mplayer
> a dvb-t/h264 stream with this card?
>
> TIA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

