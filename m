Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51742 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZBCTa4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 14:30:56 -0500
Date: Tue, 3 Feb 2009 13:42:50 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <20090203191311.2c1695b7@free.fr>
Message-ID: <alpine.LNX.2.00.0902031334550.1944@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <200901272101.27451.linux@baker-net.org.uk> <alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu> <200901272228.42610.linux@baker-net.org.uk> <20090128113540.25536301@free.fr>
 <alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu> <20090131203650.36369153@free.fr> <alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu> <20090203103925.25703074@free.fr> <alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
 <alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu> <20090203191311.2c1695b7@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-22698434-1233690141=:1944"
Content-ID: <alpine.LNX.2.00.0902031342450.1944@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-22698434-1233690141=:1944
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.LNX.2.00.0902031342451.1944@banach.math.auburn.edu>



On Tue, 3 Feb 2009, Jean-Francois Moine wrote:

> On Tue, 3 Feb 2009 12:21:55 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:
>
>> I should add to the above that now I have tested, and indeed this
>> change does not solve the problem of kernel oops after disconnect
>> while streaming. It does make one change. The xterm does not go wild
>> with error messages. But it is still not possible to close the svv
>> window. Moreover, ps ax reveals that [svv] is running as an
>> unkillable process, with [sq905/0] and [sq905/1], equally unkillable,
>> in supporting roles. And dmesg reveals an oops. The problem is after
>> all notorious by now, so I do not see much need for yet another log
>> of debug output unless specifically asked for such.
>
> Why is there 2 sq905 processes?
>
> What is the oops? (Your last trace was good, because it gave the last
> gspca/sq905 messages and the full oops)

Right, here is the output. I have not searched for precise differences, 
but a glance at it leaves me with the feeling that it is the same old same 
old. This was done on the Pentium 4 Dual Core, with gspca_main loaded with 
option debug=255, and this is the dmesg output which resulted when I 
pulled the cord of the camera.


Theodore Kilgore
---863829203-22698434-1233690141=:1944
Content-Type: APPLICATION/OCTET-STREAM; NAME=newest.txt.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0902031342210.1944@banach.math.auburn.edu>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=newest.txt.bz2

QlpoOTFBWSZTWf6KiSwAJXH/gHwQCABIf//3v6feSr/v/+BQBd3so7uNUllQ
A7YdENCE00BDJk1GNNTNTTIAAAA0aZA0ImGoaZU9TTTQAAyAAAAAAcZMmmmE
yMgYEYmjBGEGjTAAINMo1FPU3qZNQBoAGmgGQaGgPUMgAkUJpkE1PSbSYSbU
0amIekbKYjTIGnqAepW2MtQSRYgtYgdhBLDZS7iEwLRyTVRGdBZqFyeyQJAh
Lb8vl2UPNcvu2yDA8Kf5z0PK/U4jwcAvah6PWlTreGid/QaxVoeZC8s/VKUh
GmGNqOXA5gJhuv4gQJ9FsBhcEB4fuhkbdVkIIpgYBLAEnIU27RruxZaKqWKQ
7tnP9cZNZgkCEq8ISrnh+2qJM64E4kAY1jl5o8Swyjz4MH5CzGeOo9mG2fLD
AqSB412P4q3Rtr1PLC9rWx1mj2xy/6/IqURB+obI80c0DnC6ZDMe9wl2x50c
ISlSZQQzGShSpjWe26pyOzjo5RZIgtyOSHPpNU3G1bFxXkahqdlUA25RmR0S
AyNWtGWMTfhGL7VSwYmMOT0J5uNtZoEIQSJeo1PeiU7xTIgG3KAvQKYC4XqZ
JApIKqtMLIWonhtjGbCbFSrgRoIoayMVLOCI5MgSZgRVKvmm5KxL3n4DQ2mN
NsaYmm2DTBsGNtxxxyyy5pjNmMURWpBGcpa4L3caUFGJ76VxoYkTEJQxB1Gr
elHOw1i7BHGbisfiFCMXzzXsDRYUugRUOCz0ooSC6kFGBqwSoNFi4W2l1LMI
l11j32ObxIMbHHnSwSKM7nnuFOKhBJwnJIVPtRhNpTMF93NeA7cUU1YYGW67
mrru0ESYzKMIqEWOuFLLLXWWVcblC9GMEXlYDzLJksYJc9mq01WWPWrjXMpj
O8jbfGQlNApg730IKHW1zbAEYqKu2UnAPg+TzqQm9awsnACUyUFwNqvAKtAo
iItWkyT62vT5HIYH2FDBuBIEJU9FsiZ9s+3vh4X5adHsQl+MGP6DLlyt3vfx
8uUX19N446Hnm2K43Ut0tWGDZPgYTAoFFIMWJxKB3LFd+HE5yReJOWG+AcmV
xZ97wmlKUFIgjMkr8qTRbxzJLNiR3L6Rj8EhdzJBw6fS4B6OPudP9l3Q8IRr
H7PngA9xIl+oI0wDxvgWk9DmOCwzIjDQZoMKBii+e8fWarqluuvb661jzd+i
7yVBJAhLd74C6eOOt9Btx9kcOCJ02BRnXgWXL/ldKcqn71LiLrzldNPbhsI0
s92lpta5cXgrN/Dqy5AkCEs0atOD8mnGxSF8EKDAcdkkRvWnVWVQQhCV+uJb
0p9b304PAuhY1SJdBt8pIJ4MY7cdTW0Kvg5PUToYp1GkWPG8tQW432dkxSmW
kCZBoSBCUo535bo+bdCyOS5N+PZ5OP55GD63o9+PNwjiZFmYa6UyFmlZ5uvY
yIdKWJM6Lt94iqKQ2+eUAfkfUY69a4V2QgBjshz4a5gkCEtcVEZwa6ua7CJB
KHR8CPqaCpHs/bssbbaMZ5l6w26kUR1rMIxtYMXAhxtPPyCbXsQkCEp/FMJM
sApfVaay3IuaJCAyGaMlrSVxksY61WRXCAbOcs8iXrxJoCeAmFrVkqiWBO2Q
QoU8ElTQ8ak08oESmnFJHIpB7igWFt0YOTpP+cyzbvphJXIr2umxkhiI3rGU
W1WU5ZbI6xkoGuFSAQQdvPMXfszrUmXSt8ZG/OHE1XrxnOt7428vVsuDRWw3
3JAhCU4njqv8JYlxxe6BsvYbQSBCTLGSHNi2/GyFeNsIp6BY++w62FrTeIuB
qhw0bonaY1FUOqBwQOkQQS0jwnaHd7YIVHokCEJVuWoIJyUBlJvY3fbwKS+F
FPVBfOpf1IJaMxDOmHtNABCEnuvHTMeAThCO2BdZ51crVtglOMIQXpQ+bJY9
Xf3IF0tAndAUGDlYMVFA/xdyRThQkP6KiSw=

---863829203-22698434-1233690141=:1944--
