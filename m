Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:39983 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab1LAMdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 07:33:14 -0500
To: <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc: virtual DVB device
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 01 Dec 2011 13:33:13 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
In-Reply-To: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
Message-ID: <84bdeea7e55d1c5db1251e48309f2e36@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello,



On Wed, 30 Nov 2011 22:38:33 +0100, HoP <jpetrous@gmail.com> wrote:

> I have one big problem with it. I can even imagine that some "bad guys"

> could abuse virtual driver to use it for distribution close-source

drivers

> in the binary blobs. But is it that - worrying about bad boys abusing -

> the sufficient reason for such aggressive NACK which I did?



I am not a LinuxTV developer so I am not in position to take a stand for

or against this. Ultimately though, either your driver is rejected or it is

accepted. This is not really a matter of being aggressive or not. It just

so happens that many Linux-DVB contributors feel the same way against that

class of driver.



Also note the fear of GPL avoidance is not unique to Linux-DVB. If I am

not mistaken there is no user-space socket API back-end for the same

reasons. And there is also no _in-tree_ loopback V4L2 device driver in

kernel.



> Then would be better to remove loadable module API fully from kernel.

> Is it the right way?



You seem to been misrepresenting things on purpose here, and this will

never play in your favor.



> Please confirm me that worrying about abusive act is enough to NACK

> particular driver. Then I may be definitely understand I'm doing

something

> wrong and will stay (with such enemy driver) out of tree.

> 

> I can't understand that because I see very similar drivers in kernel for

> ages (nbd, or even more similar is usbip) and seems they don't hamper to

> anybody.



Sure. On That said, the Network Block Device, USB-IP and TUNTAP are not

really competing with real drivers because of their high perfomance impact,

so they are probably not the best examples to support your argument. uinput

and ALSA loopback would seem like better examples to me.



> I would like to note that I don't want to start any flame-war,

> so very short answer would be enough for me.



Did you try to implement this through CUSE? Then there should be no GPL

problems. Also then you do not need to convince anybody to take your driver

in the kernel.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
