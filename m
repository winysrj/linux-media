Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:36440 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbeFENeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Jun 2018 09:34:07 -0400
Date: Tue, 5 Jun 2018 15:34:04 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] Add BPF decoders to ir-keytable
Message-ID: <20180605133403.uniztx6t4kanjvae@camel2.lan>
References: <cover.1527941987.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1527941987.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Sat, Jun 02, 2018 at 01:37:54PM +0100, Sean Young wrote:
> This is not ready for merging yet, however while I finish this work I would
> like some feedback and ideas.
> 
> The idea is that IR decoders can be written in C, compiled to BPF relocatable
> object file. Any global variables can overriden, so we can supports lots
> of variants of similiar protocols (just like in the lircd.conf file).
> 
> The existing rc_keymap file format can't be used for variables, so I've
> converted the format to toml. An alternative would be to use the existing
> lircd.conf file format, but it's a very awkward file to parse in C and it
> contains many features which are irrelevant to us.
> 
> We use libelf to load the bpf relocatable object file.
> 
> After loading our example grundig keymap with bpf decoder, the output of
> ir-keytable is:
> 
> Found /sys/class/rc/rc0/ (/dev/input/event8) with:
> 	Name: Winbond CIR
> 	Driver: winbond-cir, table: rc-rc6-mce
> 	lirc device: /dev/lirc0
> 	Attached bpf protocols: grundig
> 	Supported protocols: lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp imon 
> 	Enabled protocols: lirc
> 	bus: 25, vendor/product: 10ad:00f1, version: 0x0004
> 	Repeat delay = 500 ms, repeat period = 125 ms

I did a few tests with this patch and noticed some issues:

clang didn't find asm/types.h, I'm running Debian Stretch here
and asm isn't in /usr/include but in /usr/include/HOST-TRIPLET
which gcc uses by default, but clang doesn't seem to know about.

With a quick workaround (adding /usr/include/x86_64-linux-gnu/
on x86_64 and /usr/include/aarch64-linux-gnu/) the grundig decoder
built fine both on x86_64 and aarch64 and grundig.o files were
identical. I noticed some pointer arithmetic warnings though:

hias@lepotato:~/install/v4l-utils/git/utils/keytable$ make
Making all in bpf_protocols
make[1]: Entering directory '/home/hias/install/v4l-utils/git/utils/keytable/bpf_protocols'
clang -I../../../include -nostdinc -isystem /usr/lib/llvm-3.8/bin/../lib/clang/3.8.1/include -I/usr/include -I/usr/include/aarch64-linux-gnu -target bpf -O2 -emit-llvm -c grundig.c -o - | llc -march=bpf -filetype=obj -o grundig.o
make[1]: Leaving directory '/home/hias/install/v4l-utils/git/utils/keytable/bpf_protocols'
make[1]: Entering directory '/home/hias/install/v4l-utils/git/utils/keytable'
  CC       keytable.o
  CC       ir-encode.o
  CC       toml.o
  CC       bpf.o
  CC       bpf_load.o
bpf_load.c: In function ‘parse_relo_and_apply’:
bpf_load.c:192:41: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]
     int32_t *p = (bpf_file->data->d_buf + sym.st_value);
                                         ^
bpf_load.c: In function ‘load_elf_maps_section’:
bpf_load.c:308:54: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]
   def = (struct bpf_load_map_def *)(data_maps->d_buf + offset);
                                                      ^
  CCLD     ir-keytable
make[1]: Leaving directory '/home/hias/install/v4l-utils/git/utils/keytable'

When trying to load the grundig decoder (tested on aarch64 with
a kernel compiled from yesterday's head of bpf-next, commit
bd3a08aaa9a3) I get an "invalid mem access 'map_value_or_null'"
error:

hias@lepotato:~/install/v4l-utils/git/utils/keytable$ sudo ./ir-keytable -c -w rc_keymaps_bpf/RP75_LCD.toml
bpf protocols removed
Old keytable cleared
Wrote 40 keycode(s) to driver
header_space (null)
header_pulse 1244
leader_pulse (null)
bpf_load_program() err=13
0: (bf) r6 = r1
1: (b7) r8 = 0
2: (63) *(u32 *)(r10 -4) = r8
3: (bf) r2 = r10
4: (07) r2 += -4
5: (18) r1 = 0xffff80006960fa00
7: (85) call bpf_map_lookup_elem#1
8: (bf) r7 = r10
9: (07) r7 += -24
10: (1d) if r0 == r8 goto pc+1
 R0=map_value_or_null(id=1,off=0,ks=4,vs=16,imm=0) R6=ctx(id=0,off=0,imm=0) R7=fp-24,call_-1 R8=inv0 R10=fp0,call_-1
11: (bf) r7 = r0
12: (7b) *(u64 *)(r10 -16) = r8
13: (7b) *(u64 *)(r10 -24) = r8
14: (61) r1 = *(u32 *)(r6 +0)
15: (18) r3 = 0xff000000
17: (bf) r2 = r1
18: (5f) r2 &= r3
19: (15) if r2 == 0x2000000 goto pc+131
 R0=map_value_or_null(id=1,off=0,ks=4,vs=16,imm=0) R1=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2=inv(id=0,umax_value=4278190080,var_off=(0x0; 0xff000000)) R3=inv4278190080 R6=ctx(id=0,off=0,imm=0) R7=map_value_or_null(id=1,off=0,ks=4,vs=16,imm=0) R8=inv0 R10=fp0,call_-1 fp-16=0 fp-24=0
20: (57) r1 &= 16777215
21: (61) r3 = *(u32 *)(r7 +4)
R7 invalid mem access 'map_value_or_null'

Not quite sure who's to blame here, clang/llvm, the grundig code or
the loader. Do you have any ideas or hints?

so long,

Hias
