Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:43232 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZEZSE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 14:04:59 -0400
Received: by pxi1 with SMTP id 1so3213339pxi.33
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 11:05:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1C2C0F.9090808@gmail.com>
References: <4A1C2C0F.9090808@gmail.com>
Date: Tue, 26 May 2009 14:05:00 -0400
Message-ID: <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
Subject: Re: [linux-dvb] EPG (Electronic Program Guide) Tools
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2009 at 1:51 PM, Chris Capon <ttabyss@gmail.com> wrote:
> Hi:
> I've installed an HVR-1600 card in a Debian system to receive ATSC
> digital broadcasts here in Canada.  Everything works great.
>
> scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > channels.conf
>
>        finds a complete list of broadcasters.
>
> azap -c channels.conf -r "channel-name"
>
>        tunes in the stations and displays signal strength info.
>
> cp /dev/dvb/adapter0/dvr0 xx.mpg
>
>        captures the output stream which can be played by mplayer.
>
>
>
> What I'm missing is information about the Electronic Program Guide
> (EPG).  There doesn't seem to be much info on linuxtv.org on how to read it.
>
> Where does the EPG come from?
>
> Is it incorporated into the output stream through PID's some how or is
> it read from one of the other devices under adapter0?
>
> Are there simple command line tools to read it or do you have to write a
> custom program to interpret it somehow?
>
> Could someone please point me in the right direction to get started?  If
> no tools exist, perhaps links to either api or lib docs/samples?
>
>
> Much appreciated.
> Chris.

Hello Chris,

The ATSC EPG is sent via the ATSC PSIP protocol.  I do not know of any
tools currently available to extract the information.  MeTV has a
working implementation (with some bugs I have seen), and I was looking
at getting it to work in Kaffeine at some point.

The spec is freely available here:

http://www.atsc.org/standards/a_65cr1_with_amend_1.pdf

If you have any questions, feel free to drop me a line.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
