Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp110.rog.mail.re2.yahoo.com ([206.190.37.120]:31766 "HELO
	smtp110.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751124AbZBVSFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 13:05:43 -0500
Message-ID: <49A193F5.8010400@rogers.com>
Date: Sun, 22 Feb 2009 13:05:41 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Laurent Haond <lhaond@bearstech.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux
 ?
References: <499F5452.6050205@bearstech.com> <7a3c9e3d0902210108w77e440e2u6d688f3614ccf972@mail.gmail.com> <499FEF0A.2070001@bearstech.com>
In-Reply-To: <499FEF0A.2070001@bearstech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Haond wrote:
> af9015_copy_firmware:
> af9015: command failed:2
> af9015: firmware copy to 2nd frontend failed, will disable it
> dvb-usb: no frontend was attached by 'AVerMedia A850'
>
> ........
>
> dvbscan fails with this error : Unable to query frontend status
> and sometimes (not everytimes) dmesg shows :
> af9015: recv bulk message failed:-110
> af9013: I2C read failed reg:d417
>
>
> Tried Kaffeine, did not work either...
>   

Just as a FYI, if you haven't already realised it yourself (though I
suspect you have),  don't bother proceeding with testing with dvbscan or
kaffeine until you get the frontend to initialize (as they are doomed to
fail otherwise).


Laurent Haond wrote:
>>> af9015_copy_firmware:
>>> af9015: command failed:2
>>> af9015: firmware copy to 2nd frontend failed, will disable it
>>> dvb-usb: no frontend was attached by 'AVerMedia A850'
>>> dvb-usb: AVerMedia A850 successfully initialized and connected.
>>>       
>> No knowledge why it fails. I suspect wrong GPIO, again this is AverMedia
>> device... You should take usb-sniff and look correct GPIO from there.
>>     
>
> I trying to do that, but i'm not able  to find a recent and working
> repository for usbreplay and parser.pl
>
> Seems that http://mcentral.de/wiki/index.php5/Usbreplay is out of date,
> and that http://mcentral.de/hg/~mrec/usbreplay is no more available.
>
> Can you point me to a working repository where i can get them ?
>   

You can find a parser in the /v4l2-apps/test directory of the v4l-dvb
source .... (I'm not sure why it is in the /test directory and not the
/util , hence my  concurrent message on the list, douglas' pull request,
regarding this).

