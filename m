Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n33DurUg020328
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 09:56:53 -0400
Received: from node02.cambriumhosting.nl (node02.cambriumhosting.nl
	[217.19.16.163])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n33DtQrH004885
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 09:56:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id 117F4B000310
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 15:55:26 +0200 (CEST)
Received: from node02.cambriumhosting.nl ([127.0.0.1])
	by localhost (node02.cambriumhosting.nl [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id e3G+FHDp607L for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 15:55:24 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl
	[84.245.3.195])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id 81C71B00030F
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 15:55:24 +0200 (CEST)
Received: from [192.168.1.239] (unknown [192.168.1.239])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id 8FC2523BC501
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 15:24:24 +0200 (CEST)
Message-ID: <49D6154A.3040208@powercraft.nl>
Date: Fri, 03 Apr 2009 15:55:22 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49D610CC.6070405@powercraft.nl> <49D6127F.2020406@powercraft.nl>
In-Reply-To: <49D6127F.2020406@powercraft.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: request list of usb dvb-t devices that work with vanilla 2.6.29
 kernel
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

Jelle de Jong wrote:
> Jelle de Jong wrote:
>> Hello everybody,
>>
>> I have been trying for years now to get support for usb based devices
>> that makes it possible to watch FTA dvb-t channels in Europa.
>>
>> I have bought more then 6 devices already and none of them work with the
>> stock vanilla kernel (or with fedora, debian kernel packages)
>>
>> I had hopes for the em28xx drivers, and spent a lots of time in the last
>> years to Markus Rechberger. I made documentation did testing, compiled
>> packages, did a lot of mailing and irc chats, etcetera.
>>
>> I always hoped the code and work would be merged back with the official
>> upstream kernel code so all this work would not be needed anymore and the
>> devices will all just work with the new kernel releases.
>>
>> I spent time sending emails and talking to developers to see how we could
>> help Markus get his code back into the kernel.
>>
>> But the situation is just sick, and there are real attitude issues on
>> both sides.
>>
>> I have gave up my hopes on getting a good healthy development process for
>> the em28xx project. I am kind of said about this, because I don't give up
>> easy and currently slowly feels that the em28xx project maybe hurting the
>> free software community more then its doing good...
>>
>> I now need new devices that do not need the em28xx code, I gave up hopes
>> on getting analog and dvb-t to work with one usb hybrid devices, so I am
>> going for a dvb-t only device.
>>
>> Can somebody help me provide a list of devices that i can buy in stores
>> and that are supported in the 2.6.29 stock kernel or have high
>> possibilities to get full support in the future.
>>
>> I would also like to point out I need a feature that allows scanning the
>> signal strength of a dvd-t channel so I can create an fully automated FTA
>> signal scanning systems that removes weaker supplicated channels.
>>
>> Best regards, (but kind of disappointed)
>>
>> Jelle de Jong
>>
> 
> I just took one of my devices out ot the storage that did not work with
> previous kernels but now works out of the box with 2.6.29:
> - Afatech AF9015 DVB-T USB2.0 stick http://debian.pastebin.com/d3e942c02
> 
> a list of more devices is really helpful.
> 

for example: what chipsets do these below devices use and are they
working with the stock 2.6.29 kernel. go/nogo/why)

http://www.informatique.nl/123286/asus-my-cinema-u3100-mini-dvb-t.html
http://www.informatique.nl/445144/conceptronic-tv/dvb-t-adapter-usb2.0.html
http://www.informatique.nl/403047/hauppauge-wintv-hvr-930c.html
http://www.informatique.nl/470187/pinnacle-pctv-72e-dvb-t-stick-ultimate.html
http://www.informatique.nl/470186/pinnacle-pctv-72e-dvb-t-stick.html

Best regards,

Jelle de Jong

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
