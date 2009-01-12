Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <darav@gmx.de>) id 1LMRG0-0000sw-Ad
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 19:11:26 +0100
Message-Id: <6940F926-0668-4B88-BF78-32C69EE51919@gmx.de>
From: darav@gmx.de
To: linux-dvb@linuxtv.org
In-Reply-To: <496B3494.4030500@okg-computer.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Mon, 12 Jan 2009 19:10:32 +0100
References: <496204D8.6090602@okg-computer.de><20090105130757.GW12059@titan.makhutov-it.de>	<49620916.7060704@dark-green.com>
	<8CB3D7E10E304E0-1674-1438@WEBMAIL-MY25.sysops.aol.com>
	<496B3494.4030500@okg-computer.de>
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi!

The same problem exists with my PCTV 400e.
It seems to be problem with the USB part.
When I enable USB-Debug- in the kernel, I get this:

ttusb2: i2c transfer failed.
dvb-usb: bulk message failed: -22 (9/70)
ttusb2: there might have been an error during control message  =

transfer. (rlen =3D 3, was 0)
...
ttusb2: i2c transfer failed.
dvb-usb: bulk message failed: -22 (9/70)
ttusb2: there might have been an error during control message  =

transfer. (rlen =3D 3, was 0)

It's the same with 2.6.28 in-kernel-drivers and with the Igor  =

Liplianin's tree.

(A also had this problem some years ago on a PPC-Mac-Mini. The  =

workaround was to disable HIGHMEM. But it doesn't work now.
I'm now on x86 32bit).

I also want to help. But how?

Best Regards,
darav

Am 12.01.2009 um 13:16 schrieb Jens Krehbiel-Gr=E4ther:

> Hi!
>
> So this problem concerns more people and should be a general bug??
> My device is working well in windows, so it could not be the dish, the
> cable or the device itself.
>
> Can I do anything for debugging this problem? Let me know!
>
> Jens
>
>
> dbox2alpha@netscape.net schrieb:
>>
>> i can confirm the very same problem symptoms with a technotrend dvb- =

>> s2
>> 3600 usb device.
>>
>> -----Original Message-----
>> From: gimli <gimli@dark-green.com>
>> To: Artem Makhutov <artem@makhutov.org>
>> Cc: linux-dvb@linuxtv.org
>> Sent: Mon, 5 Jan 2009 2:20 pm
>> Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream
>>
>> Artem Makhutov schrieb:
>>
>>> Hi,
>>
>>>
>>
>>> On Mon, Jan 05, 2009 at 02:02:16PM +0100, Jens Krehbiel-Gr=E4ther  =

>>> wrote:
>>
>>>> Hi!
>>
>>>>
>>
>>>> I use a Pinnacle USB-Receiver (PCTV Sat HDTV Pro). The module is
>>
>>>> dvb-usb-pctv452e.
>>
>>>>
>>
>>>> I use the repository from Igor Liplianin (actual hg release). The  =

>>>> module
>>
>>>> compiles and loads fine. The scanning with scan-s2 and zapping with
>>
>>>> szap-s2 also wirk fine.
>>
>>>> But when I record TV from the USB-device with "cat
>>
>>>> /dev/dvb/adapter0/dvr0 > (filename)" I got the TV-Stream of the  =

>>>> actual
>>
>>>> tv-station (zapped with "szap-s2 -r SAT.1" for example).
>>
>>>> This recorded video has artefacts, even missed frames.
>>
>>>>
>>
>>>> Anyone else having this problem? I remember that on multiproto  =

>>>> there was
>>
>>>> a similar prob
>> lem with the pctv452e until Dominik Kuhlen patched
>>
>>>> somthing since then the video was OK. Is it possible that the same
>>
>>>> "error" is in the S2API-driver?
>>
>>>
>>
>>> I have similar problems with my SkyStar HD (stb0899), but I
>>
>>> am still using the multiproto drivers.
>>
>>>
>>
>>> Regards, Artem
>>
>>>
>>
>>> _______________________________________________
>>
>>> linux-dvb mailing list
>>
>>> linux-dvb@linuxtv.org
>>
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>>
>> Hi have also a similar problem on the TerraTec Cinergy S2 PCI HD
>>
>> with the S2API drivers from the Liplianin tree.
>>
>>
>>
>> mfg
>>
>>
>>
>> Edgar (gimli) Hucek
>>
>>
>>
>> _______________________________________________
>>
>> linux-dvb mailing list
>>
>> linux-dvb@linuxtv.org
>>
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>> ------------------------------------------------------------------------
>> Get a *free MP3* every day with the Spinner.com Toolbar. Get it Now
>> <http://toolbar.aol.com/spinner/download.html?ncid=3Demlweusdown00000020 =

>> >.
>>
>> ------------------------------------------------------------------------
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux- =

> media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
