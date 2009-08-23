Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55262 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429AbZHWDOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 23:14:42 -0400
Subject: Re: Kernel oops with em28xx device
From: Andy Walls <awalls@radix.net>
To: Fau <dalamenona@gmail.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <4fab9a6f0908221732g8e061f3t8fc871c3a0b36337@mail.gmail.com>
References: <4fab9a6f0908221729n5410920fmd38bace3070105a3@mail.gmail.com>
	 <4fab9a6f0908221732g8e061f3t8fc871c3a0b36337@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 23:16:11 -0400
Message-Id: <1250997371.5363.57.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-08-23 at 02:32 +0200, Fau wrote:
> Greetings,
> I have an USB TV adapter identified as Hauppauge WinTV HVR 900 (R2) (card=18)
> and I'm using Fedora 11 with linux kernel vanilla 2.6.30.5 (the last
> stable as writing).
> 
> Following the manual at http://www.linuxtv.org/wiki/index.php/Em28xx_devices
> i've extracted and copied xc3028-v27.fw in /lib/firware then i
> compiled (make/make install) a freshly cloned v4l-dvb
> 
> Now when the device is plugged there is a kernel oops, I'm missing
> something or is it a bug?
> In attachment the relevant part of dmesg,
> thank you in advance for any help,
> 
> --
> Fab

The oops was in i2c_master_send().  With my ancient kernel that code
looks like:

int i2c_master_send(struct i2c_client *client,const char *buf ,int count)
{       
        int ret;
        struct i2c_adapter *adap=client->adapter;
        struct i2c_msg msg;             
        
        msg.addr = client->addr;
        msg.flags = client->flags & I2C_M_TEN;
        msg.len = count;
        msg.buf = (char *)buf;
....


The code in your dump disassembles to this:

ffffffdf <.data>:
ffdf:	f0 83 e0 10          	lock and $0x10,%eax
ffe3:	83 c8 01             	or     $0x1,%eax
ffe6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
ffea:	89 f0                	mov    %esi,%eax
ffec:	e8 d7 f6 ff ff       	call   0xfffff6c8
fff1:	83 f8 01             	cmp    $0x1,%eax
fff4:	0f 45 d8             	cmovne %eax,%ebx
fff7:	83 c4 0c             	add    $0xc,%esp
fffa:	89 d8                	mov    %ebx,%eax
fffc:	5b                   	pop    %ebx
fffd:	5e                   	pop    %esi
fffe:	5d                   	pop    %ebp
ffff:	c3                   	ret    
   0:	55                   	push   %ebp           Beginning of i2c_master_send()
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	89 cb                	mov    %ecx,%ebx
   7:	83 ec 0c             	sub    $0xc,%esp        struct i2c_msg msg;
   a:	66 8b 48 02          	mov    0x2(%eax),%cx    msg.addr = client->addr <------------ client %eax is NULL
   e:	8b 70 18             	mov    0x18(%eax),%esi	struct i2c_adapter *adap=client->adapter;
  11:	66 89 4d ec          	mov    %cx,-0x14(%ebp)
  15:	8b 00                	mov    (%eax),%eax      msg.flags = client->flags ...
  17:	b9 01 00 00 00       	mov    $0x1,%ecx
  1c:	89 55 f4             	mov    %edx,-0xc(%ebp)

So client is NULL when calling i2c_master_send().

[  232.702984] EIP: 0060:[<c1267324>] EFLAGS: 00010282 CPU: 0
[  232.702988] EIP is at i2c_master_send+0xa/0x43
[  232.702992] EAX: 00000000 EBX: 00000002 ECX: 00000002 EDX: f653bcfe

[  232.703006] Call Trace:
[  232.703006]  [<fa36af5e>] ? em28xx_write_regs+0x1a/0x4c [em28xx]
[  232.703006]  [<fa38313f>] ? tvp5150_write+0x47/0x6f [tvp5150]
[  232.703006]  [<fa38367e>] ? tvp5150_selmux+0x67/0xac [tvp5150]
[  232.703006]  [<fa3836c3>] ? tvp5150_s_routing+0x0/0x12 [tvp5150]
[  232.703006]  [<fa3836d1>] ? tvp5150_s_routing+0xe/0x12 [tvp5150]
[  232.703006]  [<fa36a8f7>] ? em28xx_wake_i2c+0x6b/0xaa [em28xx]
[  232.703006]  [<fa36a734>] ? em28xx_usb_probe+0x6a3/0x7fb [em28xx]
[  232.703006]  [<c123abed>] ? usb_probe_interface+0x110/0x156


I don't see how em28xx_write_regs() can possibly start an I2C
transaction, so it must start when em28xx_wake_i2c() calls

   v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
                        INPUT(dev->ctl_input)->vmux, 0, 0);

tvp5150_write() fetches the i2c_client pointer from the v4l2_subdev data
and it is NULL.  Which is odd, because tvp5150_probe() sets the client
data properly as evinced by this message:

	[  231.441378] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)

I find the apparent re-entrance into the tvp5150_s_routing function
above strange.

Well, I can see what's broken, but not why or how.  Time to turn on
tvp5150 debugging....


Regards,
Andy

