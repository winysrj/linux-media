Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P8tDTr019401
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:55:13 -0400
Received: from node01.cambriumhosting.nl (node01.cambriumhosting.nl
	[217.19.16.162])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3P8sr10010550
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 04:54:53 -0400
Message-ID: <49F2CFD5.5070101@powercraft.nl>
Date: Sat, 25 Apr 2009 10:54:45 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <49D644CD.1040307@powercraft.nl>
	<49D64E45.2070303@powercraft.nl>	<49DC5033.4000803@powercraft.nl>
	<49F1B2A4.3060404@powercraft.nl> <49F20259.1090302@iki.fi>
	<49F2C312.4030808@powercraft.nl> <49F2C710.2000906@iki.fi>
In-Reply-To: <49F2C710.2000906@iki.fi>
Content-Type: multipart/mixed; boundary="------------090304020307080500030207"
Cc: video4linux-list@redhat.com
Subject: Re: one dvb-t devices not working with mplayer the other is, what
 is going wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------090304020307080500030207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Antti Palosaari wrote:
> On 04/25/2009 11:00 AM, Jelle de Jong wrote:
>> Antti Palosaari wrote:
>>> On 04/24/2009 03:37 PM, Jelle de Jong wrote:
>>>> Jelle de Jong wrote:
>>>>> Jelle de Jong wrote:
>>>>>> Jelle de Jong wrote:
>>>>>>> Hello everybody,
>>>>>>>
>>>>>>> As you may read in my previous thread, i am trying to switch from my
>>>>>>> em28xx devices to a device that works with gpl compliant upstream kernel
>>>>>>> source code.
>>>>>>>
>>>>>>> My em28xx devices all played back video and audio only dvb-t channels:
>>>>>>> Pinnacle PCTV Hybrid Pro Stick 330e
>>>>>>> Terratec Cinergy Hybrid T USB XS
>>>>>>> Hauppauge WinTV HVR 900
>>>>>>>
>>>>>>> I build script for this to automate the process, however i now swiched to
>>>>>>> my dvb-t only usb device:
>>>>>>> Afatech AF9015 DVB-T USB2.0 stick
>>>>>>>
>>>>>>> And it with totem-xine it plays the same as the em28xx devices, so the
>>>>>>> devices does kind of works (see the totem-xine bug, please commit to this
>>>>>>> bug if you have the same behavior)
>>>>>>>
>>>>>>> # device info
>>>>>>> http://debian.pastebin.com/d3e942c02
>>>>>>>
>>>>>>> # totem-xine bug
>>>>>>> http://bugzilla.gnome.org/show_bug.cgi?id=554319
>>>>>>>
>>>>>>> # mplayer issue
>>>>>>> http://debian.pastebin.com/d34d92e64
>>>>>>> ^ anybody have any idea what the heck goes on why doesn't mplayer work
>>>>>>> with this device, nothing changed in the commands i used.
>>>>>>>
>>>>>>> using:
>>>>>>> mplayer
>>>>>>> Version: 1:1.0.rc2svn20090330-0.0
>>>>>>> linux-image-2.6.29-1-686
>>>>>>> Version: 2.6.29-1
>>>>>>>
>>>>>>> Thanks in advance, for any help.
>>>>>>>
>>>>>>> Best regards,
>>>>>>>
>>>>>>> Jelle de Jong
>>>>>> some more info:
>>>>>>
>>>>>> device0 (not working, Afatech AF9013 DVB-T)
>>>>>> http://filebin.ca/ypxkw/mplayer0.log
>>>>>>
>>>>>> device1 (working, Micronas DRX3973D DVB-T, em28xx, markus not gpl code)
>>>>>> http://filebin.ca/zecdjm/mplayer1.log
>>>>>>
>>>>>> device2 (working, Zarlink MT352 DVB-T, em28xx, markus not gpl code)
>>>>>> http://filebin.ca/fzxtcx/mplayer2.log
>>>>>>
>>>>>> All devices work with totem-xine but only the em28xx devices works with
>>>>>> mplayer, whats going on?
>>>>>>
>>>>> Anybody?
>>>>>
>>>>> Best regards,
>>>>>
>>>>> Jelle
>>>>>
>>>> Would somebody be willing to test this with there device, see the first
>>>> mail for the commands I used, they are in the attached files.
>>>>
>>>> Being able to use mplayer to listen to dvb-t radio is mandatory for me.
>>> I use tzap&  mplayer always when testing driver. Never seen troubles you
>>> have. And I have very many AF9015 devices. How did you launch mplayer?
>>>
>>> Antti
>>
>> I don't use tzap directly.
>>
>> This is what I do:
>>
>> # step 1: I use wscan to to make a channel list, there are some serious
>> issues under Linux that I cant solve but like to know what is being done
>> about is. The wscan tool cant get the signal strength of the channel it
>> found, so it may find duplicated channels on multiple frequencies with
>> different strengths. wscan should be able to eliminate all the duplicated
>> channels with inferiour quality. But there is no API in v4l to do this.
>>
>> ~/.wscan/wscan -t 3 -E 0 -O 0 -X tzap>  ~/.wscan/channels.conf
>> cp --verbose ~/.wscan/channels.conf ~/.mplayer/channels.conf
>>
>> # step 2: I run the mplayer command to play one of the stream
>> /usr/bin/mplayer -dvbin timeout=10 dvb://"3FM(Digitenne)"
> 
> Works just OK here.
> 
>> I automated this scanning and playing system with scripts, they are
>> attached together with the logs of the commands I run.
> 
> device0.log
> AF9015: you are using very old firmware. Otherwise it seems to be OK.
> 
> device3.log
> em28xx: crashes the Kernel => sure have problems. Are you mixing the 
> drivers from v4l-dvb and from mcentral.de?
> 
>> These systems work with the em28xx devices but not with the AF9015
> 
> 
> I think the reason is that you have tainted your Kernel with em28xx 
> drivers which makes it crashing. Please install clean v4l-dvb from 
> linuxtv.org, install new firmware reboot machine and test again.
> 
> regards
> Antti

Hmm, I used the latest Debian kernel available in unstable and
experimental, so I used the stock kernel. If this is to old I cant really
 help this and have to wait until Debian releases a new kernel. There is
no residue in my current kernel of any em28xx code its a complete clean
stock Debian kernel.

I don't know about the age of the firmware, but I believe its extracted
from the kernel code it tells me:
[ 4689.481452] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[ 4689.975618] af9013: firmware version:4.65.0

Ignore the em28xx devices they have proprietary code, and is not
mainstream developed, no use wasting energy on that. Been there, done that.

What is your kernel and firmware version? Is there a way to easily add a
newer firmware file without recompilation?

Best regards,

Jelle

--------------090304020307080500030207
Content-Type: text/plain;
 name="test0.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="test0.txt"

WyAyMjY0LjEzNjM1MF0gdXNiIDEtMy4yOiBuZXcgZnVsbCBzcGVlZCBVU0IgZGV2aWNlIHVz
aW5nIGVoY2lfaGNkIGFuZCBhZGRyZXNzIDYKWyAyMjY0LjIzODMyM10gdXNiIDEtMy4yOiBO
ZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MDRlNiwgaWRQcm9kdWN0PTUxMTUKWyAy
MjY0LjIzODMzMV0gdXNiIDEtMy4yOiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MSwg
UHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9NQpbIDIyNjQuMjM4MzM3XSB1c2IgMS0zLjI6IFBy
b2R1Y3Q6IFNDUjMzeCBVU0IgU21hcnQgQ2FyZCBSZWFkZXIKWyAyMjY0LjIzODM0MV0gdXNi
IDEtMy4yOiBNYW51ZmFjdHVyZXI6IFNDTSBNaWNyb3N5c3RlbXMgSW5jLgpbIDIyNjQuMjM4
MzQ1XSB1c2IgMS0zLjI6IFNlcmlhbE51bWJlcjogMjExMjA2MTgyMDEwNDEKWyAyMjY0LjIz
ODU0Nl0gdXNiIDEtMy4yOiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBmcm9tIDEgY2hvaWNl
ClsgNDY4OS4yNjAwNjFdIHVzYiAxLTI6IG5ldyBoaWdoIHNwZWVkIFVTQiBkZXZpY2UgdXNp
bmcgZWhjaV9oY2QgYW5kIGFkZHJlc3MgNwpbIDQ2ODkuMzk2MDA1XSB1c2IgMS0yOiBOZXcg
VVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MTVhNCwgaWRQcm9kdWN0PTkwMTYKWyA0Njg5
LjM5NjAzMl0gdXNiIDEtMjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTEsIFByb2R1
Y3Q9MiwgU2VyaWFsTnVtYmVyPTAKWyA0Njg5LjM5NjA0MF0gdXNiIDEtMjogUHJvZHVjdDog
RFZCLVQKWyA0Njg5LjM5NjA0NF0gdXNiIDEtMjogTWFudWZhY3R1cmVyOiBBZmF0ZWNoClsg
NDY4OS4zOTYyNTBdIHVzYiAxLTI6IGNvbmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBj
aG9pY2UKWyA0Njg5LjM5OTg2N10gQWZhdGVjaCBEVkItVDogRml4aW5nIGZ1bGxzcGVlZCB0
byBoaWdoc3BlZWQgaW50ZXJ2YWw6IDE2IC0+IDgKWyA0Njg5LjQxMjkxM10gaW5wdXQ6IEFm
YXRlY2ggRFZCLVQgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFkLjcvdXNiMS8x
LTIvMS0yOjEuMS9pbnB1dC9pbnB1dDEyClsgNDY4OS40NDkzNDFdIGdlbmVyaWMtdXNiIDAw
MDM6MTVBNDo5MDE2LjAwMDQ6IGlucHV0LGhpZHJhdzM6IFVTQiBISUQgdjEuMDEgS2V5Ym9h
cmQgW0FmYXRlY2ggRFZCLVRdIG9uIHVzYi0wMDAwOjAwOjFkLjctMi9pbnB1dDEKWyA0Njg5
LjQ2Njc0NF0gZHZiLXVzYjogZm91bmQgYSAnQWZhdGVjaCBBRjkwMTUgRFZCLVQgVVNCMi4w
IHN0aWNrJyBpbiBjb2xkIHN0YXRlLCB3aWxsIHRyeSB0byBsb2FkIGEgZmlybXdhcmUKWyA0
Njg5LjQ2Njc1Nl0gdXNiIDEtMjogZmlybXdhcmU6IHJlcXVlc3RpbmcgZHZiLXVzYi1hZjkw
MTUuZncKWyA0Njg5LjQ4MTQ1Ml0gZHZiLXVzYjogZG93bmxvYWRpbmcgZmlybXdhcmUgZnJv
bSBmaWxlICdkdmItdXNiLWFmOTAxNS5mdycKWyA0Njg5LjUzNTI4MF0gZHZiLXVzYjogZm91
bmQgYSAnQWZhdGVjaCBBRjkwMTUgRFZCLVQgVVNCMi4wIHN0aWNrJyBpbiB3YXJtIHN0YXRl
LgpbIDQ2ODkuNTM1MzcxXSBkdmItdXNiOiB3aWxsIHBhc3MgdGhlIGNvbXBsZXRlIE1QRUcy
IHRyYW5zcG9ydCBzdHJlYW0gdG8gdGhlIHNvZnR3YXJlIGRlbXV4ZXIuClsgNDY4OS41MzU3
ODBdIERWQjogcmVnaXN0ZXJpbmcgbmV3IGFkYXB0ZXIgKEFmYXRlY2ggQUY5MDE1IERWQi1U
IFVTQjIuMCBzdGljaykKWyA0Njg5Ljk3NTYxOF0gYWY5MDEzOiBmaXJtd2FyZSB2ZXJzaW9u
OjQuNjUuMApbIDQ2ODkuOTgwMTIzXSBEVkI6IHJlZ2lzdGVyaW5nIGFkYXB0ZXIgMCBmcm9u
dGVuZCAwIChBZmF0ZWNoIEFGOTAxMyBEVkItVCkuLi4KWyA0NjkwLjAxMjEyOF0gTVQyMDYw
OiBzdWNjZXNzZnVsbHkgaWRlbnRpZmllZCAoSUYxID0gMTIyMCkKWyA0NjkwLjQ4Mzg3N10g
ZHZiLXVzYjogQWZhdGVjaCBBRjkwMTUgRFZCLVQgVVNCMi4wIHN0aWNrIHN1Y2Nlc3NmdWxs
eSBpbml0aWFsaXplZCBhbmQgY29ubmVjdGVkLgpbIDQ2OTAuNDkyMTg4XSB1c2Jjb3JlOiBy
ZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGR2Yl91c2JfYWY5MDE1CgokIHVuYW1l
IC1hCkxpbnV4IGRlYmlhbi1lZWVwYyAyLjYuMjktMS02ODYgIzEgU01QIEZyaSBBcHIgMTcg
MTQ6MzU6MTYgVVRDIDIwMDkgaTY4NiBHTlUvTGludXgKCiQgZHBrZyAtbCB8IGdyZXAgMi42
LjI5CmlpICBsaW51eC1pbWFnZS0yLjYuMjktMS02ODYgICAgMi42LjI5LTMgICAgTGludXgg
Mi42LjI5IGltYWdlIG9uIFBQcm8vQ2VsZXJvbi9QSUkvUElJSS9QNAppaSAgbGludXgtbGli
Yy1kZXYgICAgICAgICAgICAgIDIuNi4yOS0zICAgIExpbnV4IHN1cHBvcnQgaGVhZGVycyBm
b3IgdXNlcnNwYWNlIGRldmVsb3BtZW50CgokIC91c3IvYmluL21wbGF5ZXIgLWR2YmluIHRp
bWVvdXQ9MTAgZHZiOi8vIjNGTShEaWdpdGVubmUpIgpNUGxheWVyIGRldi1TVk4tcjI5MTcw
Q2FuJ3Qgb3BlbiBqb3lzdGljayBkZXZpY2UgL2Rldi9pbnB1dC9qczA6IE5vIHN1Y2ggZmls
ZSBvciBkaXJlY3RvcnkKQ2FuJ3QgaW5pdCBpbnB1dCBqb3lzdGljawptcGxheWVyOiBjb3Vs
ZCBub3QgY29ubmVjdCB0byBzb2NrZXQKbXBsYXllcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVj
dG9yeQpGYWlsZWQgdG8gb3BlbiBMSVJDIHN1cHBvcnQuIFlvdSB3aWxsIG5vdCBiZSBhYmxl
IHRvIHVzZSB5b3VyIHJlbW90ZSBjb250cm9sLgoKUGxheWluZyBkdmI6Ly8zRk0oRGlnaXRl
bm5lKS4KZHZiX3R1bmUgRnJlcTogNzIyMDAwMDAwCk5vdCBhYmxlIHRvIGxvY2sgdG8gdGhl
IHNpZ25hbCBvbiB0aGUgZ2l2ZW4gZnJlcXVlbmN5LCB0aW1lb3V0OiAxMApkdmJfdHVuZSwg
VFVOSU5HIEZBSUxFRApFUlJPUiwgQ09VTEROJ1QgU0VUIENIQU5ORUwgIDc6IEZhaWxlZCB0
byBvcGVuIGR2YjovLzNGTShEaWdpdGVubmUpLgoKCkV4aXRpbmcuLi4gKEVuZCBvZiBmaWxl
KQo=
--------------090304020307080500030207
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090304020307080500030207--
