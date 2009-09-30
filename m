Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.agmk.net ([91.192.224.71]:49743 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbZI3IQU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 04:16:20 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Date: Wed, 30 Sep 2009 10:16:15 +0200
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
References: <200909160300.28382.pluto@agmk.net> <200909161003.33090.pluto@agmk.net> <20090929161629.2a5c8d30@hyperion.delvare>
In-Reply-To: <20090929161629.2a5c8d30@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PPxwKa03B9Ea8uP"
Message-Id: <200909301016.15327.pluto@agmk.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_PPxwKa03B9Ea8uP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tuesday 29 September 2009 16:16:29 Jean Delvare wrote:
> On Wed, 16 Sep 2009 10:03:32 +0200, Paweł Sikora wrote:
> > On Wednesday 16 September 2009 08:57:01 Jean Delvare wrote:
> > > Hi Pawel,
> > >
> > > I think this would be fixed by the following patch:
> > > http://patchwork.kernel.org/patch/45707/
> >
> > still oopses. this time i've attached full dmesg.
> 
> Any news on this? Do you have a refined list of kernels which have the
> bug and kernels which do not?

afaics in the 2.6.2{7,8}, the remote sends some noises to pc.
effect: random characters on terminal and unusable login prompt.

now in the 2.6.31, the kernel module oopses during udev loading.
so i've renamed the .ko to prevent loading.

> Tried 2.6.32-rc1? Tried the v4l-dvb repository?

no.

> I am also skeptical about the +0x64/0x1a52, ir_input_init() is a rather
> small function and I fail to see how it could be 6738 bytes in binary size.

i've attached asm dump of ir-common.ko
i found the '41 c7 80 cc ...' code in dump at adress 0x83e.

--Boundary-00=_PPxwKa03B9Ea8uP
Content-Type: text/plain;
  charset="utf-8";
  name="ir-common.asm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ir-common.asm"


ir-common.ko:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <ir_extract_bits>:
   0:	31 c0                	xor    %eax,%eax
   2:	ba 01 00 00 00       	mov    $0x1,%edx
   7:	eb 09                	jmp    12 <ir_extract_bits+0x12>
   9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  10:	d1 ef                	shr    %edi
  12:	40 f6 c6 01          	test   $0x1,%sil
  16:	74 0d                	je     25 <ir_extract_bits+0x25>
  18:	89 c1                	mov    %eax,%ecx
  1a:	09 d1                	or     %edx,%ecx
  1c:	40 f6 c7 01          	test   $0x1,%dil
  20:	0f 45 c1             	cmovne %ecx,%eax
  23:	01 d2                	add    %edx,%edx
  25:	d1 ee                	shr    %esi
  27:	75 e7                	jne    10 <ir_extract_bits+0x10>
  29:	f3 c3                	repz retq 
  2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000030 <ir_decode_pulsedistance>:
  30:	41 55                	push   %r13
  32:	c1 e6 05             	shl    $0x5,%esi
  35:	85 f6                	test   %esi,%esi
  37:	41 54                	push   %r12
  39:	55                   	push   %rbp
  3a:	53                   	push   %rbx
  3b:	89 cb                	mov    %ecx,%ebx
  3d:	7e 58                	jle    97 <ir_decode_pulsedistance+0x67>
  3f:	31 c0                	xor    %eax,%eax
  41:	45 31 c0             	xor    %r8d,%r8d
  44:	41 bb 1f 00 00 00    	mov    $0x1f,%r11d
  4a:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  50:	eb 12                	jmp    64 <ir_decode_pulsedistance+0x34>
  52:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  58:	41 83 c0 01          	add    $0x1,%r8d
  5c:	83 c0 01             	add    $0x1,%eax
  5f:	41 39 f0             	cmp    %esi,%r8d
  62:	7d 33                	jge    97 <ir_decode_pulsedistance+0x67>
  64:	44 89 c1             	mov    %r8d,%ecx
  67:	45 89 c1             	mov    %r8d,%r9d
  6a:	44 89 dd             	mov    %r11d,%ebp
  6d:	83 e1 1f             	and    $0x1f,%ecx
  70:	41 c1 f9 05          	sar    $0x5,%r9d
  74:	45 89 d5             	mov    %r10d,%r13d
  77:	29 cd                	sub    %ecx,%ebp
  79:	4d 63 c9             	movslq %r9d,%r9
  7c:	89 e9                	mov    %ebp,%ecx
  7e:	41 d3 e5             	shl    %cl,%r13d
  81:	46 85 2c 8f          	test   %r13d,(%rdi,%r9,4)
  85:	75 d1                	jne    58 <ir_decode_pulsedistance+0x28>
  87:	83 f8 1c             	cmp    $0x1c,%eax
  8a:	7f 1c                	jg     a8 <ir_decode_pulsedistance+0x78>
  8c:	41 83 c0 01          	add    $0x1,%r8d
  90:	31 c0                	xor    %eax,%eax
  92:	41 39 f0             	cmp    %esi,%r8d
  95:	7c cd                	jl     64 <ir_decode_pulsedistance+0x34>
  97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  9c:	5b                   	pop    %rbx
  9d:	5d                   	pop    %rbp
  9e:	41 5c                	pop    %r12
  a0:	41 5d                	pop    %r13
  a2:	c3                   	retq   
  a3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  a8:	41 39 f0             	cmp    %esi,%r8d
  ab:	7d ea                	jge    97 <ir_decode_pulsedistance+0x67>
  ad:	31 c0                	xor    %eax,%eax
  af:	41 bb 1f 00 00 00    	mov    $0x1f,%r11d
  b5:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  bb:	eb 26                	jmp    e3 <ir_decode_pulsedistance+0xb3>
  bd:	0f 1f 00             	nopl   (%rax)
  c0:	44 89 c1             	mov    %r8d,%ecx
  c3:	45 89 c1             	mov    %r8d,%r9d
  c6:	44 89 dd             	mov    %r11d,%ebp
  c9:	83 e1 1f             	and    $0x1f,%ecx
  cc:	41 c1 f9 05          	sar    $0x5,%r9d
  d0:	45 89 d5             	mov    %r10d,%r13d
  d3:	29 cd                	sub    %ecx,%ebp
  d5:	4d 63 c9             	movslq %r9d,%r9
  d8:	89 e9                	mov    %ebp,%ecx
  da:	41 d3 e5             	shl    %cl,%r13d
  dd:	46 85 2c 8f          	test   %r13d,(%rdi,%r9,4)
  e1:	75 0c                	jne    ef <ir_decode_pulsedistance+0xbf>
  e3:	41 83 c0 01          	add    $0x1,%r8d
  e7:	83 c0 01             	add    $0x1,%eax
  ea:	41 39 f0             	cmp    %esi,%r8d
  ed:	7c d1                	jl     c0 <ir_decode_pulsedistance+0x90>
  ef:	83 f8 06             	cmp    $0x6,%eax
  f2:	7e a3                	jle    97 <ir_decode_pulsedistance+0x67>
  f4:	31 c0                	xor    %eax,%eax
  f6:	41 39 f0             	cmp    %esi,%r8d
  f9:	7d a1                	jge    9c <ir_decode_pulsedistance+0x6c>
  fb:	8d 14 13             	lea    (%rbx,%rdx,1),%edx
  fe:	31 ed                	xor    %ebp,%ebp
 100:	41 bb 01 00 00 00    	mov    $0x1,%r11d
 106:	45 31 d2             	xor    %r10d,%r10d
 109:	41 b9 1f 00 00 00    	mov    $0x1f,%r9d
 10f:	bb 01 00 00 00       	mov    $0x1,%ebx
 114:	41 89 d4             	mov    %edx,%r12d
 117:	41 c1 ec 1f          	shr    $0x1f,%r12d
 11b:	41 01 d4             	add    %edx,%r12d
 11e:	ba 01 00 00 00       	mov    $0x1,%edx
 123:	41 d1 fc             	sar    %r12d
 126:	eb 1d                	jmp    145 <ir_decode_pulsedistance+0x115>
 128:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 12f:	00 
 130:	85 c0                	test   %eax,%eax
 132:	75 54                	jne    188 <ir_decode_pulsedistance+0x158>
 134:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 13a:	31 d2                	xor    %edx,%edx
 13c:	41 83 c0 01          	add    $0x1,%r8d
 140:	41 39 f0             	cmp    %esi,%r8d
 143:	7d 50                	jge    195 <ir_decode_pulsedistance+0x165>
 145:	44 89 c1             	mov    %r8d,%ecx
 148:	44 89 c0             	mov    %r8d,%eax
 14b:	45 89 cd             	mov    %r9d,%r13d
 14e:	83 e1 1f             	and    $0x1f,%ecx
 151:	c1 f8 05             	sar    $0x5,%eax
 154:	41 29 cd             	sub    %ecx,%r13d
 157:	48 98                	cltq   
 159:	44 89 e9             	mov    %r13d,%ecx
 15c:	41 89 dd             	mov    %ebx,%r13d
 15f:	41 d3 e5             	shl    %cl,%r13d
 162:	44 85 2c 87          	test   %r13d,(%rdi,%rax,4)
 166:	0f 95 c0             	setne  %al
 169:	85 d2                	test   %edx,%edx
 16b:	0f b6 c0             	movzbl %al,%eax
 16e:	75 c0                	jne    130 <ir_decode_pulsedistance+0x100>
 170:	85 c0                	test   %eax,%eax
 172:	74 1b                	je     18f <ir_decode_pulsedistance+0x15f>
 174:	89 e8                	mov    %ebp,%eax
 176:	44 09 d8             	or     %r11d,%eax
 179:	45 39 d4             	cmp    %r10d,%r12d
 17c:	0f 4c e8             	cmovl  %eax,%ebp
 17f:	45 01 db             	add    %r11d,%r11d
 182:	41 83 fb 01          	cmp    $0x1,%r11d
 186:	74 0d                	je     195 <ir_decode_pulsedistance+0x165>
 188:	ba 01 00 00 00       	mov    $0x1,%edx
 18d:	eb ad                	jmp    13c <ir_decode_pulsedistance+0x10c>
 18f:	41 83 c2 01          	add    $0x1,%r10d
 193:	eb a7                	jmp    13c <ir_decode_pulsedistance+0x10c>
 195:	89 e8                	mov    %ebp,%eax
 197:	e9 00 ff ff ff       	jmpq   9c <ir_decode_pulsedistance+0x6c>
 19c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000001a0 <ir_decode_biphase>:
 1a0:	41 56                	push   %r14
 1a2:	44 8b 0f             	mov    (%rdi),%r9d
 1a5:	45 31 c0             	xor    %r8d,%r8d
 1a8:	b8 01 00 00 00       	mov    $0x1,%eax
 1ad:	41 55                	push   %r13
 1af:	41 54                	push   %r12
 1b1:	55                   	push   %rbp
 1b2:	89 cd                	mov    %ecx,%ebp
 1b4:	53                   	push   %rbx
 1b5:	bb 1f 00 00 00       	mov    $0x1f,%ebx
 1ba:	eb 12                	jmp    1ce <ir_decode_biphase+0x2e>
 1bc:	0f 1f 40 00          	nopl   0x0(%rax)
 1c0:	41 83 c0 01          	add    $0x1,%r8d
 1c4:	41 83 f8 20          	cmp    $0x20,%r8d
 1c8:	0f 84 f2 00 00 00    	je     2c0 <ir_decode_biphase+0x120>
 1ce:	44 89 c1             	mov    %r8d,%ecx
 1d1:	41 89 da             	mov    %ebx,%r10d
 1d4:	41 89 c6             	mov    %eax,%r14d
 1d7:	83 e1 1f             	and    $0x1f,%ecx
 1da:	41 29 ca             	sub    %ecx,%r10d
 1dd:	44 89 d1             	mov    %r10d,%ecx
 1e0:	41 d3 e6             	shl    %cl,%r14d
 1e3:	45 85 ce             	test   %r9d,%r14d
 1e6:	74 d8                	je     1c0 <ir_decode_biphase+0x20>
 1e8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
 1ee:	c1 e6 05             	shl    $0x5,%esi
 1f1:	44 39 c6             	cmp    %r8d,%esi
 1f4:	0f 8e ce 00 00 00    	jle    2c8 <ir_decode_biphase+0x128>
 1fa:	85 ed                	test   %ebp,%ebp
 1fc:	0f 88 c6 00 00 00    	js     2c8 <ir_decode_biphase+0x128>
 202:	b8 01 00 00 00       	mov    $0x1,%eax
 207:	45 31 d2             	xor    %r10d,%r10d
 20a:	45 31 c9             	xor    %r9d,%r9d
 20d:	41 bd 1f 00 00 00    	mov    $0x1f,%r13d
 213:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 219:	eb 24                	jmp    23f <ir_decode_biphase+0x9f>
 21b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 220:	41 83 c1 01          	add    $0x1,%r9d
 224:	41 83 c2 01          	add    $0x1,%r10d
 228:	41 83 c0 01          	add    $0x1,%r8d
 22c:	44 39 c6             	cmp    %r8d,%esi
 22f:	7e 6f                	jle    2a0 <ir_decode_biphase+0x100>
 231:	41 39 e9             	cmp    %ebp,%r9d
 234:	7f 6a                	jg     2a0 <ir_decode_biphase+0x100>
 236:	41 83 fa 01          	cmp    $0x1,%r10d
 23a:	7f 64                	jg     2a0 <ir_decode_biphase+0x100>
 23c:	41 89 cb             	mov    %ecx,%r11d
 23f:	41 8d 58 1f          	lea    0x1f(%r8),%ebx
 243:	45 85 c0             	test   %r8d,%r8d
 246:	45 89 c6             	mov    %r8d,%r14d
 249:	41 0f 49 d8          	cmovns %r8d,%ebx
 24d:	41 c1 fe 1f          	sar    $0x1f,%r14d
 251:	41 c1 ee 1b          	shr    $0x1b,%r14d
 255:	c1 fb 05             	sar    $0x5,%ebx
 258:	43 8d 0c 30          	lea    (%r8,%r14,1),%ecx
 25c:	48 63 db             	movslq %ebx,%rbx
 25f:	83 e1 1f             	and    $0x1f,%ecx
 262:	44 29 f1             	sub    %r14d,%ecx
 265:	45 89 ee             	mov    %r13d,%r14d
 268:	41 29 ce             	sub    %ecx,%r14d
 26b:	44 89 f1             	mov    %r14d,%ecx
 26e:	45 89 e6             	mov    %r12d,%r14d
 271:	41 d3 e6             	shl    %cl,%r14d
 274:	44 85 34 9f          	test   %r14d,(%rdi,%rbx,4)
 278:	0f 95 c1             	setne  %cl
 27b:	0f b6 c9             	movzbl %cl,%ecx
 27e:	41 39 cb             	cmp    %ecx,%r11d
 281:	74 2d                	je     2b0 <ir_decode_biphase+0x110>
 283:	44 39 ca             	cmp    %r9d,%edx
 286:	7f 98                	jg     220 <ir_decode_biphase+0x80>
 288:	01 c0                	add    %eax,%eax
 28a:	41 83 c0 01          	add    $0x1,%r8d
 28e:	45 31 d2             	xor    %r10d,%r10d
 291:	09 c8                	or     %ecx,%eax
 293:	44 39 c6             	cmp    %r8d,%esi
 296:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 29c:	7f 93                	jg     231 <ir_decode_biphase+0x91>
 29e:	66 90                	xchg   %ax,%ax
 2a0:	5b                   	pop    %rbx
 2a1:	5d                   	pop    %rbp
 2a2:	41 5c                	pop    %r12
 2a4:	41 5d                	pop    %r13
 2a6:	41 5e                	pop    %r14
 2a8:	c3                   	retq   
 2a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 2b0:	41 83 c1 01          	add    $0x1,%r9d
 2b4:	e9 6f ff ff ff       	jmpq   228 <ir_decode_biphase+0x88>
 2b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 2c0:	45 31 db             	xor    %r11d,%r11d
 2c3:	e9 26 ff ff ff       	jmpq   1ee <ir_decode_biphase+0x4e>
 2c8:	b8 01 00 00 00       	mov    $0x1,%eax
 2cd:	0f 1f 00             	nopl   (%rax)
 2d0:	eb ce                	jmp    2a0 <ir_decode_biphase+0x100>
 2d2:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
 2d9:	1f 84 00 00 00 00 00 

00000000000002e0 <ir_dump_samples>:
 2e0:	41 56                	push   %r14
 2e2:	31 c0                	xor    %eax,%eax
 2e4:	41 55                	push   %r13
 2e6:	41 54                	push   %r12
 2e8:	49 89 fc             	mov    %rdi,%r12
 2eb:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 2f2:	55                   	push   %rbp
 2f3:	89 f5                	mov    %esi,%ebp
 2f5:	c1 e5 05             	shl    $0x5,%ebp
 2f8:	53                   	push   %rbx
 2f9:	e8 00 00 00 00       	callq  2fe <ir_dump_samples+0x1e>
 2fe:	85 ed                	test   %ebp,%ebp
 300:	7e 5d                	jle    35f <ir_dump_samples+0x7f>
 302:	31 d2                	xor    %edx,%edx
 304:	31 db                	xor    %ebx,%ebx
 306:	41 be 1f 00 00 00    	mov    $0x1f,%r14d
 30c:	41 bd 01 00 00 00    	mov    $0x1,%r13d
 312:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 318:	89 d9                	mov    %ebx,%ecx
 31a:	44 89 f6             	mov    %r14d,%esi
 31d:	89 d8                	mov    %ebx,%eax
 31f:	83 e1 1f             	and    $0x1f,%ecx
 322:	c1 f8 05             	sar    $0x5,%eax
 325:	29 ce                	sub    %ecx,%esi
 327:	48 98                	cltq   
 329:	89 f1                	mov    %esi,%ecx
 32b:	44 89 ee             	mov    %r13d,%esi
 32e:	d3 e6                	shl    %cl,%esi
 330:	89 f1                	mov    %esi,%ecx
 332:	41 85 0c 84          	test   %ecx,(%r12,%rax,4)
 336:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
 33d:	74 41                	je     380 <ir_dump_samples+0xa0>
 33f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 346:	31 c0                	xor    %eax,%eax
 348:	e8 00 00 00 00       	callq  34d <ir_dump_samples+0x6d>
 34d:	ba 01 00 00 00       	mov    $0x1,%edx
 352:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 358:	83 c3 01             	add    $0x1,%ebx
 35b:	39 eb                	cmp    %ebp,%ebx
 35d:	7c b9                	jl     318 <ir_dump_samples+0x38>
 35f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 366:	31 c0                	xor    %eax,%eax
 368:	e8 00 00 00 00       	callq  36d <ir_dump_samples+0x8d>
 36d:	5b                   	pop    %rbx
 36e:	5d                   	pop    %rbp
 36f:	41 5c                	pop    %r12
 371:	41 5d                	pop    %r13
 373:	31 c0                	xor    %eax,%eax
 375:	41 5e                	pop    %r14
 377:	c3                   	retq   
 378:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 37f:	00 
 380:	85 d2                	test   %edx,%edx
 382:	74 d4                	je     358 <ir_dump_samples+0x78>
 384:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
 38b:	eb b2                	jmp    33f <ir_dump_samples+0x5f>
 38d:	0f 1f 00             	nopl   (%rax)
 390:	55                   	push   %rbp
 391:	48 89 f5             	mov    %rsi,%rbp
 394:	53                   	push   %rbx
 395:	48 89 fb             	mov    %rdi,%rbx
 398:	48 83 ec 08          	sub    $0x8,%rsp
 39c:	8b 96 0c 02 00 00    	mov    0x20c(%rsi),%edx
 3a2:	85 d2                	test   %edx,%edx
 3a4:	74 37                	je     3dd <ir_dump_samples+0xfd>
 3a6:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 3ac <ir_dump_samples+0xcc>
 3ac:	85 c0                	test   %eax,%eax
 3ae:	7f 54                	jg     404 <ir_dump_samples+0x124>
 3b0:	31 c9                	xor    %ecx,%ecx
 3b2:	83 bd 10 02 00 00 00 	cmpl   $0x0,0x210(%rbp)
 3b9:	48 89 df             	mov    %rbx,%rdi
 3bc:	be 01 00 00 00       	mov    $0x1,%esi
 3c1:	0f 95 c1             	setne  %cl
 3c4:	e8 00 00 00 00       	callq  3c9 <ir_dump_samples+0xe9>
 3c9:	48 83 c4 08          	add    $0x8,%rsp
 3cd:	48 89 df             	mov    %rbx,%rdi
 3d0:	31 c9                	xor    %ecx,%ecx
 3d2:	5b                   	pop    %rbx
 3d3:	5d                   	pop    %rbp
 3d4:	31 d2                	xor    %edx,%edx
 3d6:	31 f6                	xor    %esi,%esi
 3d8:	e9 00 00 00 00       	jmpq   3dd <ir_dump_samples+0xfd>
 3dd:	8b 8e 04 02 00 00    	mov    0x204(%rsi),%ecx
 3e3:	8b 96 08 02 00 00    	mov    0x208(%rsi),%edx
 3e9:	31 c0                	xor    %eax,%eax
 3eb:	44 8b 86 10 02 00 00 	mov    0x210(%rsi),%r8d
 3f2:	48 8b 37             	mov    (%rdi),%rsi
 3f5:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 3fc:	5b                   	pop    %rbx
 3fd:	5b                   	pop    %rbx
 3fe:	5d                   	pop    %rbp
 3ff:	e9 00 00 00 00       	jmpq   404 <ir_dump_samples+0x124>
 404:	8b 8e 10 02 00 00    	mov    0x210(%rsi),%ecx
 40a:	48 8b 37             	mov    (%rdi),%rsi
 40d:	31 c0                	xor    %eax,%eax
 40f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 416:	e8 00 00 00 00       	callq  41b <ir_dump_samples+0x13b>
 41b:	8b 95 0c 02 00 00    	mov    0x20c(%rbp),%edx
 421:	eb 8d                	jmp    3b0 <ir_dump_samples+0xd0>
 423:	66 66 66 66 2e 0f 1f 	nopw   %cs:0x0(%rax,%rax,1)
 42a:	84 00 00 00 00 00 

0000000000000430 <ir_input_keydown>:
 430:	48 83 ec 28          	sub    $0x28,%rsp
 434:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
 439:	45 31 e4             	xor    %r12d,%r12d
 43c:	83 fa 7f             	cmp    $0x7f,%edx
 43f:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
 444:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
 449:	48 89 f3             	mov    %rsi,%rbx
 44c:	48 89 fd             	mov    %rdi,%rbp
 44f:	77 07                	ja     458 <ir_input_keydown+0x28>
 451:	89 d0                	mov    %edx,%eax
 453:	44 8b 64 86 04       	mov    0x4(%rsi,%rax,4),%r12d
 458:	8b bb 10 02 00 00    	mov    0x210(%rbx),%edi
 45e:	85 ff                	test   %edi,%edi
 460:	75 3e                	jne    4a0 <ir_input_keydown+0x70>
 462:	89 93 08 02 00 00    	mov    %edx,0x208(%rbx)
 468:	89 8b 04 02 00 00    	mov    %ecx,0x204(%rbx)
 46e:	48 89 de             	mov    %rbx,%rsi
 471:	44 89 a3 0c 02 00 00 	mov    %r12d,0x20c(%rbx)
 478:	c7 83 10 02 00 00 01 	movl   $0x1,0x210(%rbx)
 47f:	00 00 00 
 482:	48 89 ef             	mov    %rbp,%rdi
 485:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
 48a:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
 48f:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
 494:	48 83 c4 28          	add    $0x28,%rsp
 498:	e9 f3 fe ff ff       	jmpq   390 <ir_dump_samples+0xb0>
 49d:	0f 1f 00             	nopl   (%rax)
 4a0:	44 3b a3 0c 02 00 00 	cmp    0x20c(%rbx),%r12d
 4a7:	74 2d                	je     4d6 <ir_input_keydown+0xa6>
 4a9:	c7 83 10 02 00 00 00 	movl   $0x0,0x210(%rbx)
 4b0:	00 00 00 
 4b3:	48 89 de             	mov    %rbx,%rsi
 4b6:	48 89 ef             	mov    %rbp,%rdi
 4b9:	89 54 24 08          	mov    %edx,0x8(%rsp)
 4bd:	89 0c 24             	mov    %ecx,(%rsp)
 4c0:	e8 cb fe ff ff       	callq  390 <ir_dump_samples+0xb0>
 4c5:	8b b3 10 02 00 00    	mov    0x210(%rbx),%esi
 4cb:	8b 54 24 08          	mov    0x8(%rsp),%edx
 4cf:	8b 0c 24             	mov    (%rsp),%ecx
 4d2:	85 f6                	test   %esi,%esi
 4d4:	74 8c                	je     462 <ir_input_keydown+0x32>
 4d6:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
 4db:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
 4e0:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
 4e5:	48 83 c4 28          	add    $0x28,%rsp
 4e9:	c3                   	retq   
 4ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000004f0 <ir_input_nokey>:
 4f0:	48 83 ec 08          	sub    $0x8,%rsp
 4f4:	44 8b 86 10 02 00 00 	mov    0x210(%rsi),%r8d
 4fb:	45 85 c0             	test   %r8d,%r8d
 4fe:	75 08                	jne    508 <ir_input_nokey+0x18>
 500:	48 83 c4 08          	add    $0x8,%rsp
 504:	c3                   	retq   
 505:	0f 1f 00             	nopl   (%rax)
 508:	c7 86 10 02 00 00 00 	movl   $0x0,0x210(%rsi)
 50f:	00 00 00 
 512:	48 83 c4 08          	add    $0x8,%rsp
 516:	e9 75 fe ff ff       	jmpq   390 <ir_dump_samples+0xb0>
 51b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000520 <ir_rc5_timer_keyup>:
 520:	44 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9d        # 527 <ir_rc5_timer_keyup+0x7>
 527:	53                   	push   %rbx
 528:	48 89 fb             	mov    %rdi,%rbx
 52b:	45 85 c9             	test   %r9d,%r9d
 52e:	7f 0d                	jg     53d <ir_rc5_timer_keyup+0x1d>
 530:	48 8d 73 08          	lea    0x8(%rbx),%rsi
 534:	48 8b 3b             	mov    (%rbx),%rdi
 537:	5b                   	pop    %rbx
 538:	e9 00 00 00 00       	jmpq   53d <ir_rc5_timer_keyup+0x1d>
 53d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 544:	31 c0                	xor    %eax,%eax
 546:	e8 00 00 00 00       	callq  54b <ir_rc5_timer_keyup+0x2b>
 54b:	eb e3                	jmp    530 <ir_rc5_timer_keyup+0x10>
 54d:	0f 1f 00             	nopl   (%rax)

0000000000000550 <ir_rc5_timer_end>:
 550:	48 83 ec 48          	sub    $0x48,%rsp
 554:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
 559:	48 89 fb             	mov    %rdi,%rbx
 55c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
 561:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
 566:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
 56b:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
 570:	4c 89 74 24 40       	mov    %r14,0x40(%rsp)
 575:	4c 8b 25 00 00 00 00 	mov    0x0(%rip),%r12        # 57c <ir_rc5_timer_end+0x2c>
 57c:	e8 00 00 00 00       	callq  581 <ir_rc5_timer_end+0x31>
 581:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 586:	48 2b 83 b0 03 00 00 	sub    0x3b0(%rbx),%rax
 58d:	48 83 f8 01          	cmp    $0x1,%rax
 591:	0f 8e a9 00 00 00    	jle    640 <ir_rc5_timer_end+0xf0>
 597:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%rbx)
 59e:	00 00 00 
 5a1:	83 bb a4 03 00 00 13 	cmpl   $0x13,0x3a4(%rbx)
 5a8:	76 66                	jbe    610 <ir_rc5_timer_end+0xc0>
 5aa:	8b 93 a8 03 00 00    	mov    0x3a8(%rbx),%edx
 5b0:	8b 8b 70 02 00 00    	mov    0x270(%rbx),%ecx
 5b6:	31 f6                	xor    %esi,%esi
 5b8:	31 ed                	xor    %ebp,%ebp
 5ba:	d3 e2                	shl    %cl,%edx
 5bc:	83 ca 01             	or     $0x1,%edx
 5bf:	89 93 a8 03 00 00    	mov    %edx,0x3a8(%rbx)
 5c5:	89 d0                	mov    %edx,%eax
 5c7:	89 c1                	mov    %eax,%ecx
 5c9:	01 ed                	add    %ebp,%ebp
 5cb:	c1 e8 02             	shr    $0x2,%eax
 5ce:	83 e1 03             	and    $0x3,%ecx
 5d1:	83 f9 01             	cmp    $0x1,%ecx
 5d4:	0f 84 f6 00 00 00    	je     6d0 <ir_rc5_timer_end+0x180>
 5da:	83 f9 03             	cmp    $0x3,%ecx
 5dd:	0f 84 a5 00 00 00    	je     688 <ir_rc5_timer_end+0x138>
 5e3:	83 c6 01             	add    $0x1,%esi
 5e6:	83 fe 0e             	cmp    $0xe,%esi
 5e9:	75 dc                	jne    5c7 <ir_rc5_timer_end+0x77>
 5eb:	44 8b 2d 00 00 00 00 	mov    0x0(%rip),%r13d        # 5f2 <ir_rc5_timer_end+0xa2>
 5f2:	45 85 ed             	test   %r13d,%r13d
 5f5:	0f 8f bb 01 00 00    	jg     7b6 <ir_rc5_timer_end+0x266>
 5fb:	41 89 ed             	mov    %ebp,%r13d
 5fe:	41 c1 ed 0c          	shr    $0xc,%r13d
 602:	41 83 e5 03          	and    $0x3,%r13d
 606:	e9 92 00 00 00       	jmpq   69d <ir_rc5_timer_end+0x14d>
 60b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 610:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 616 <ir_rc5_timer_end+0xc6>
 616:	85 c0                	test   %eax,%eax
 618:	0f 8f 54 01 00 00    	jg     772 <ir_rc5_timer_end+0x222>
 61e:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
 623:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
 628:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
 62d:	4c 8b 6c 24 38       	mov    0x38(%rsp),%r13
 632:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
 637:	48 83 c4 48          	add    $0x48,%rsp
 63b:	c3                   	retq   
 63c:	0f 1f 40 00          	nopl   0x0(%rax)
 640:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 645:	2b 93 b8 03 00 00    	sub    0x3b8(%rbx),%edx
 64b:	69 c0 40 42 0f 00    	imul   $0xf4240,%eax,%eax
 651:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%rbx)
 658:	00 00 00 
 65b:	8d 04 02             	lea    (%rdx,%rax,1),%eax
 65e:	3d 5f 6d 00 00       	cmp    $0x6d5f,%eax
 663:	0f 87 38 ff ff ff    	ja     5a1 <ir_rc5_timer_end+0x51>
 669:	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 66f <ir_rc5_timer_end+0x11f>
 66f:	85 d2                	test   %edx,%edx
 671:	7e ab                	jle    61e <ir_rc5_timer_end+0xce>
 673:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 67a:	31 c0                	xor    %eax,%eax
 67c:	e8 00 00 00 00       	callq  681 <ir_rc5_timer_end+0x131>
 681:	eb 9b                	jmp    61e <ir_rc5_timer_end+0xce>
 683:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 688:	44 8b 35 00 00 00 00 	mov    0x0(%rip),%r14d        # 68f <ir_rc5_timer_end+0x13f>
 68f:	45 85 f6             	test   %r14d,%r14d
 692:	0f 8f f3 00 00 00    	jg     78b <ir_rc5_timer_end+0x23b>
 698:	45 31 ed             	xor    %r13d,%r13d
 69b:	31 ed                	xor    %ebp,%ebp
 69d:	44 39 ab 74 02 00 00 	cmp    %r13d,0x274(%rbx)
 6a4:	74 3a                	je     6e0 <ir_rc5_timer_end+0x190>
 6a6:	44 8b 1d 00 00 00 00 	mov    0x0(%rip),%r11d        # 6ad <ir_rc5_timer_end+0x15d>
 6ad:	45 85 db             	test   %r11d,%r11d
 6b0:	0f 8e 68 ff ff ff    	jle    61e <ir_rc5_timer_end+0xce>
 6b6:	44 89 ee             	mov    %r13d,%esi
 6b9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 6c0:	31 c0                	xor    %eax,%eax
 6c2:	e8 00 00 00 00       	callq  6c7 <ir_rc5_timer_end+0x177>
 6c7:	e9 52 ff ff ff       	jmpq   61e <ir_rc5_timer_end+0xce>
 6cc:	0f 1f 40 00          	nopl   0x0(%rax)
 6d0:	83 cd 01             	or     $0x1,%ebp
 6d3:	e9 0b ff ff ff       	jmpq   5e3 <ir_rc5_timer_end+0x93>
 6d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 6df:	00 
 6e0:	89 e8                	mov    %ebp,%eax
 6e2:	c1 e8 06             	shr    $0x6,%eax
 6e5:	83 e0 1f             	and    $0x1f,%eax
 6e8:	3b 83 78 02 00 00    	cmp    0x278(%rbx),%eax
 6ee:	0f 85 2a ff ff ff    	jne    61e <ir_rc5_timer_end+0xce>
 6f4:	8b 8b a0 03 00 00    	mov    0x3a0(%rbx),%ecx
 6fa:	89 ea                	mov    %ebp,%edx
 6fc:	41 89 ed             	mov    %ebp,%r13d
 6ff:	c1 ea 0b             	shr    $0xb,%edx
 702:	41 83 e5 3f          	and    $0x3f,%r13d
 706:	83 e2 01             	and    $0x1,%edx
 709:	89 c8                	mov    %ecx,%eax
 70b:	c1 e8 0b             	shr    $0xb,%eax
 70e:	83 e0 01             	and    $0x1,%eax
 711:	39 d0                	cmp    %edx,%eax
 713:	74 52                	je     767 <ir_rc5_timer_end+0x217>
 715:	44 8b 15 00 00 00 00 	mov    0x0(%rip),%r10d        # 71c <ir_rc5_timer_end+0x1cc>
 71c:	45 85 d2             	test   %r10d,%r10d
 71f:	7f 7f                	jg     7a0 <ir_rc5_timer_end+0x250>
 721:	4c 8d 73 08          	lea    0x8(%rbx),%r14
 725:	48 8b 3b             	mov    (%rbx),%rdi
 728:	4c 89 f6             	mov    %r14,%rsi
 72b:	e8 00 00 00 00       	callq  730 <ir_rc5_timer_end+0x1e0>
 730:	48 8b 3b             	mov    (%rbx),%rdi
 733:	44 89 e9             	mov    %r13d,%ecx
 736:	44 89 ea             	mov    %r13d,%edx
 739:	4c 89 f6             	mov    %r14,%rsi
 73c:	e8 00 00 00 00       	callq  741 <ir_rc5_timer_end+0x1f1>
 741:	8b bb 7c 02 00 00    	mov    0x27c(%rbx),%edi
 747:	e8 00 00 00 00       	callq  74c <ir_rc5_timer_end+0x1fc>
 74c:	48 8d bb 50 03 00 00 	lea    0x350(%rbx),%rdi
 753:	4a 8d 34 20          	lea    (%rax,%r12,1),%rsi
 757:	e8 00 00 00 00       	callq  75c <ir_rc5_timer_end+0x20c>
 75c:	89 ab a0 03 00 00    	mov    %ebp,0x3a0(%rbx)
 762:	e9 b7 fe ff ff       	jmpq   61e <ir_rc5_timer_end+0xce>
 767:	83 e1 3f             	and    $0x3f,%ecx
 76a:	44 39 e9             	cmp    %r13d,%ecx
 76d:	75 a6                	jne    715 <ir_rc5_timer_end+0x1c5>
 76f:	90                   	nop
 770:	eb cf                	jmp    741 <ir_rc5_timer_end+0x1f1>
 772:	8b b3 a8 03 00 00    	mov    0x3a8(%rbx),%esi
 778:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 77f:	31 c0                	xor    %eax,%eax
 781:	e8 00 00 00 00       	callq  786 <ir_rc5_timer_end+0x236>
 786:	e9 93 fe ff ff       	jmpq   61e <ir_rc5_timer_end+0xce>
 78b:	89 d6                	mov    %edx,%esi
 78d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 794:	31 c0                	xor    %eax,%eax
 796:	e8 00 00 00 00       	callq  79b <ir_rc5_timer_end+0x24b>
 79b:	e9 f8 fe ff ff       	jmpq   698 <ir_rc5_timer_end+0x148>
 7a0:	44 89 ee             	mov    %r13d,%esi
 7a3:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 7aa:	31 c0                	xor    %eax,%eax
 7ac:	e8 00 00 00 00       	callq  7b1 <ir_rc5_timer_end+0x261>
 7b1:	e9 6b ff ff ff       	jmpq   721 <ir_rc5_timer_end+0x1d1>
 7b6:	41 89 ed             	mov    %ebp,%r13d
 7b9:	41 89 e9             	mov    %ebp,%r9d
 7bc:	41 89 e8             	mov    %ebp,%r8d
 7bf:	41 c1 ed 0c          	shr    $0xc,%r13d
 7c3:	89 e8                	mov    %ebp,%eax
 7c5:	41 c1 e9 06          	shr    $0x6,%r9d
 7c9:	83 e0 3f             	and    $0x3f,%eax
 7cc:	41 83 e5 03          	and    $0x3,%r13d
 7d0:	41 c1 e8 0b          	shr    $0xb,%r8d
 7d4:	89 04 24             	mov    %eax,(%rsp)
 7d7:	41 83 e1 1f          	and    $0x1f,%r9d
 7db:	41 83 e0 01          	and    $0x1,%r8d
 7df:	44 89 e9             	mov    %r13d,%ecx
 7e2:	89 ee                	mov    %ebp,%esi
 7e4:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 7eb:	31 c0                	xor    %eax,%eax
 7ed:	e8 00 00 00 00       	callq  7f2 <ir_rc5_timer_end+0x2a2>
 7f2:	e9 a6 fe ff ff       	jmpq   69d <ir_rc5_timer_end+0x14d>
 7f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 7fe:	00 00 

0000000000000800 <ir_input_init>:
 800:	48 85 c9             	test   %rcx,%rcx
 803:	89 16                	mov    %edx,(%rsi)
 805:	49 89 f8             	mov    %rdi,%r8
 808:	48 89 f0             	mov    %rsi,%rax
 80b:	48 8d 56 04          	lea    0x4(%rsi),%rdx
 80f:	74 22                	je     833 <ir_input_init+0x33>
 811:	f6 c2 04             	test   $0x4,%dl
 814:	48 89 d7             	mov    %rdx,%rdi
 817:	48 89 ce             	mov    %rcx,%rsi
 81a:	41 b9 00 02 00 00    	mov    $0x200,%r9d
 820:	75 77                	jne    899 <ir_input_init+0x99>
 822:	44 89 c9             	mov    %r9d,%ecx
 825:	c1 e9 03             	shr    $0x3,%ecx
 828:	41 83 e1 04          	and    $0x4,%r9d
 82c:	89 c9                	mov    %ecx,%ecx
 82e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
 831:	75 60                	jne    893 <ir_input_init+0x93>
 833:	49 8d 48 28          	lea    0x28(%r8),%rcx
 837:	49 89 90 d0 00 00 00 	mov    %rdx,0xd0(%r8)
 83e:	41 c7 80 cc 00 00 00 	movl   $0x4,0xcc(%r8)
 845:	04 00 00 00 
 849:	41 c7 80 c8 00 00 00 	movl   $0x80,0xc8(%r8)
 850:	80 00 00 00 
 854:	31 d2                	xor    %edx,%edx
 856:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 85d:	00 00 00 
 860:	8b 74 10 04          	mov    0x4(%rax,%rdx,1),%esi
 864:	f0 0f ab 31          	lock bts %esi,(%rcx)
 868:	48 83 c2 04          	add    $0x4,%rdx
 86c:	48 81 fa 00 02 00 00 	cmp    $0x200,%rdx
 873:	75 eb                	jne    860 <ir_input_init+0x60>
 875:	f0 41 80 60 28 fe    	lock andb $0xfe,0x28(%r8)
 87b:	f0 41 80 48 20 02    	lock orb $0x2,0x20(%r8)
 881:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 887 <ir_input_init+0x87>
 887:	85 c9                	test   %ecx,%ecx
 889:	74 06                	je     891 <ir_input_init+0x91>
 88b:	f0 41 80 48 22 10    	lock orb $0x10,0x22(%r8)
 891:	f3 c3                	repz retq 
 893:	8b 0e                	mov    (%rsi),%ecx
 895:	89 0f                	mov    %ecx,(%rdi)
 897:	eb 9a                	jmp    833 <ir_input_init+0x33>
 899:	8b 09                	mov    (%rcx),%ecx
 89b:	48 8d 78 08          	lea    0x8(%rax),%rdi
 89f:	48 83 c6 04          	add    $0x4,%rsi
 8a3:	66 41 b9 fc 01       	mov    $0x1fc,%r9w
 8a8:	89 48 04             	mov    %ecx,0x4(%rax)
 8ab:	e9 72 ff ff ff       	jmpq   822 <ir_input_init+0x22>

--Boundary-00=_PPxwKa03B9Ea8uP--
