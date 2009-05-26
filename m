Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:61253 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZEZTSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:18:15 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1495507fgg.17
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 12:18:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
References: <4A1C2C0F.9090808@gmail.com>
	 <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
Date: Tue, 26 May 2009 14:18:16 -0500
Message-ID: <1767e6740905261218i307d3bdeh30eec0539e98f896@mail.gmail.com>
Subject: Re: [linux-dvb] EPG (Electronic Program Guide) Tools
From: Jonathan Isom <jeisom@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, May 26, 2009, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Tue, May 26, 2009 at 1:51 PM, Chris Capon <ttabyss@gmail.com> wrote:
>> Hi:
>> I've installed an HVR-1600 card in a Debian system to receive ATSC
>> digital broadcasts here in Canada.  Everything works great.
>>
>> scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > channels.conf
>>
>>        finds a complete list of broadcasters.
>>
>> azap -c channels.conf -r "channel-name"
>>
>>        tunes in the stations and displays signal strength info.
>>
>> cp /dev/dvb/adapter0/dvr0 xx.mpg
>>
>>        captures the output stream which can be played by mplayer.
>>
>>
>>
>> What I'm missing is information about the Electronic Program Guide
>> (EPG).  There doesn't seem to be much info on linuxtv.org on how to read it.
>>
>> Where does the EPG come from?
>>
>> Is it incorporated into the output stream through PID's some how or is
>> it read from one of the other devices under adapter0?
>>
>> Are there simple command line tools to read it or do you have to write a
>> custom program to interpret it somehow?
>>
>> Could someone please point me in the right direction to get started?  If
>> no tools exist, perhaps links to either api or lib docs/samples?
>>
>>
>> Much appreciated.
>> Chris.
>
> Hello Chris,
>
> The ATSC EPG is sent via the ATSC PSIP protocol.  I do not know of any
> tools currently available to extract the information.  MeTV has a
> working implementation (with some bugs I have seen), and I was looking
> at getting it to work in Kaffeine at some point.
>
Dvbstreamer supports atsc epg. That is what i use
> The spec is freely available here:
>
> http://www.atsc.org/standards/a_65cr1_with_amend_1.pdf
>
> If you have any questions, feel free to drop me a line.
>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

-- 

ASUS m3a78 mothorboard
AMD Athlon64 X2 Dual Core Processor 6000+ 3.1Ghz
4 Gigabytes of memory
Gigabyte NVidia 9400gt  Graphics adapter
Kworld ATSC 110 TV Capture Card
Kworld ATSC 115 TV Capture Card
