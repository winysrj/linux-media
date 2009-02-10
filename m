Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZBJLiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 06:38:23 -0500
Date: Tue, 10 Feb 2009 09:37:53 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Eduard Huguet <eduardhc@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: cx8802.ko module not being built with current HG tree
Message-ID: <20090210093753.69b21572@pedra.chehab.org>
In-Reply-To: <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
	<617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/11lUi.R6L+435uQmUQ9kQpi"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/11lUi.R6L+435uQmUQ9kQpi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 5 Feb 2009 16:59:16 +0100
Eduard Huguet <eduardhc@gmail.com> wrote:

> Hi,
>   Maybe I'm wrong, but I think there is something wrong in current
> Kconfig file for cx88 drivers. I've been struggling for some hours
> trying to find why, after compiling a fresh copy of the LinuxTV HG
> drivers, I wasn't unable to modprobe cx88-dvb module, which I need for
> HVR-3000.
> 
> The module was not being load because kernel was failing to find
> cx8802_get_driver, etc... entry points, which are exported by
> cx88-mpeg.c.
> 
> The strange part is that, according to the cx88/Kconfig file this file
> should be automatically added as dependency if either CX88_DVB or
> CX88_BLACKBIRD were selected,
> but for some strange reason it wasn't.
> 
> After a 'make menuconfig' in HG tree the kernel configuration
> contained these lines (this was using the default config, without
> adding / removing anything):
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_ALSA=m
> CONFIG_VIDEO_CX88_BLACKBIRD=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_MPEG=y
> CONFIG_VIDEO_CX88_VP3054=m
> 
> Notice that they are all marked as 'm' excepting
> CONFIG_VIDEO_CX88_MPEG, which is marked as 'y'. I don't know if it's
> relevant or not, but the fact is that the module was not being
> compiled at all. The option was not visible inside menuconfig, by the
> way.
> 
> I've done some changes inside Kconfig to make it visible in
> menuconfig, and by doing this I've been able to set it to 'm' and
> rebuild, which has just worked apparently.
> 
> This Kconfig file was edited in revisions 10190 & 10191, precisely for
> reasons related to cx8802 dependencies, so I'm not sure the solution
> taken there was the right one.
> 
> Best regards,
>  Eduard Huguet

Eduard,

I suspect that this is some bug on the out-of-tree build. In order to test it,
I've tried to reproduce what I think you did.

So, I ran the following procedures over the devel branch on my -git tree:

make allmodconfig (to select everything as 'm')
I manually unselect all drivers at the tree, keeping only CX88 and submodules.
All CX88 submodules as "M".

I've repeated the procedure, this time starting with make allyesconfig.

On both cases, I got those configs:

CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m

My -git tree were updated up to this changeset:

commit 67e70baf043cfdcdaf5972bc94be82632071536b
Author: Devin Heitmueller <dheitmueller@linuxtv.org>
Date:   Mon Jan 26 03:07:59 2009 -0300

    V4L/DVB (10411): s5h1409: Perform s5h1409 soft reset after tuning


I tried also reproduce the bug you've mentioned at the v4l-dvb tree, but
unfortunately, I couldn't (the .config file is attached). I got exactly the
same result as compiling in-kernel.

Could you please send us your buggy .config?

Cheers,
Mauro

--MP_/11lUi.R6L+435uQmUQ9kQpi
Content-Type: application/octet-stream; name=v4l_config
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=v4l_config

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IEtFUk5FTFZFUlNJT04KIyBUdWUgRmViIDEwIDA5OjMyOjI2IDIw
MDkKIwpDT05GSUdfSU5QVVQ9eQpDT05GSUdfVVNCPXkKQ09ORklHX1BBUlBPUlQ9bQojIENPTkZJ
R19Bdm9pZHMgaXMgbm90IHNldAojIENPTkZJR19kdWUgaXMgbm90IHNldAojIENPTkZJR19TUEFS
QzY0IGlzIG5vdCBzZXQKIyBDT05GSUdfb2YgaXMgbm90IHNldAojIENPTkZJR19NIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUExBVF9NMzI3MDBVVCBpcyBub3Qgc2V0CkNPTkZJR19ORVQ9eQpDT05GSUdf
RkJfQ0ZCX0NPUFlBUkVBPXkKIyBDT05GSUdfR0VORVJJQ19HUElPIGlzIG5vdCBzZXQKIyBDT05G
SUdfU09VTkRfUFJJTUUgaXMgbm90IHNldApDT05GSUdfU05EX0FDOTdfQ09ERUM9bQojIENPTkZJ
R19QWEEyN3ggaXMgbm90IHNldAojIENPTkZJR19kZXBlbmRlbmNpZXMgaXMgbm90IHNldAojIENP
TkZJR19TR0lfSVAyMiBpcyBub3Qgc2V0CkNPTkZJR19JMkM9bQpDT05GSUdfRkJfQ0ZCX0lNQUdF
QkxJVD15CiMgQ09ORklHX0dQSU9fUENBOTUzWCBpcyBub3Qgc2V0CkNPTkZJR19TVEFOREFMT05F
PXkKIyBDT05GSUdfSEFWRV9DTEsgaXMgbm90IHNldApDT05GSUdfU05EX01QVTQwMV9VQVJUPW0K
Q09ORklHX1NORD1tCiMgQ09ORklHX1kgaXMgbm90IHNldApDT05GSUdfTU9EVUxFUz15CkNPTkZJ
R19TTkRfT1BMM19MSUI9bQpDT05GSUdfSEFTX0lPTUVNPXkKIyBDT05GSUdfQVJDSF9PTUFQMiBp
cyBub3Qgc2V0CkNPTkZJR19QUk9DX0ZTPXkKIyBDT05GSUdfU1BBUkMzMiBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZJREVPX1NBQTcxMTUgaXMgbm90IHNldApDT05GSUdfSTJDX0FMR09CSVQ9bQojIENP
TkZJR19EVkJfRkVfQ1VTVE9NSVpFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVIgaXMgbm90IHNldAoj
IENPTkZJR190byBpcyBub3Qgc2V0CiMgQ09ORklHX01FRElBX1RVTkVSX0NVU1RPTUlTRSBpcyBu
b3Qgc2V0CkNPTkZJR19IQVNfRE1BPXkKIyBDT05GSUdfcHZydXNiIGlzIG5vdCBzZXQKQ09ORklH
X0lORVQ9eQpDT05GSUdfQ1JDMzI9eQpDT05GSUdfRkI9eQpDT05GSUdfU1lTRlM9eQojIENPTkZJ
R19EVkIgaXMgbm90IHNldAojIENPTkZJR19JU0EgaXMgbm90IHNldApDT05GSUdfUENJPXkKQ09O
RklHX1NPTllfTEFQVE9QPW0KQ09ORklHX1NORF9QQ009bQpDT05GSUdfUEFSUE9SVF8xMjg0PXkK
Q09ORklHX0VYUEVSSU1FTlRBTD15CiMgQ09ORklHX00zMlIgaXMgbm90IHNldAojIENPTkZJR19J
MkNfQUxHT19TR0kgaXMgbm90IHNldApDT05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKQ09ORklHX1ZJ
UlRfVE9fQlVTPXkKIyBDT05GSUdfVklERU9fS0VSTkVMX1ZFUlNJT04gaXMgbm90IHNldAoKIwoj
IE11bHRpbWVkaWEgZGV2aWNlcwojCgojCiMgTXVsdGltZWRpYSBjb3JlIHN1cHBvcnQKIwpDT05G
SUdfVklERU9fREVWPXkKQ09ORklHX1ZJREVPX1Y0TDJfQ09NTU9OPW0KQ09ORklHX1ZJREVPX0FM
TE9XX1Y0TDE9eQpDT05GSUdfVklERU9fVjRMMV9DT01QQVQ9eQpDT05GSUdfRFZCX0NPUkU9eQpD
T05GSUdfVklERU9fTUVESUE9eQoKIwojIE11bHRpbWVkaWEgZHJpdmVycwojCkNPTkZJR19NRURJ
QV9BVFRBQ0g9eQpDT05GSUdfTUVESUFfVFVORVI9bQojIENPTkZJR19NRURJQV9UVU5FUl9DVVNU
T01JWkUgaXMgbm90IHNldApDT05GSUdfTUVESUFfVFVORVJfU0lNUExFPW0KQ09ORklHX01FRElB
X1RVTkVSX1REQTgyOTA9bQpDT05GSUdfTUVESUFfVFVORVJfVERBOTg4Nz1tCkNPTkZJR19NRURJ
QV9UVU5FUl9URUE1NzYxPW0KQ09ORklHX01FRElBX1RVTkVSX1RFQTU3Njc9bQpDT05GSUdfTUVE
SUFfVFVORVJfTVQyMFhYPW0KQ09ORklHX01FRElBX1RVTkVSX1hDMjAyOD1tCkNPTkZJR19NRURJ
QV9UVU5FUl9YQzUwMDA9bQpDT05GSUdfTUVESUFfVFVORVJfTUM0NFM4MDM9bQpDT05GSUdfVklE
RU9fVjRMMj1tCkNPTkZJR19WSURFT19WNEwxPW0KQ09ORklHX1ZJREVPQlVGX0dFTj1tCkNPTkZJ
R19WSURFT0JVRl9ETUFfU0c9bQpDT05GSUdfVklERU9CVUZfRFZCPW0KQ09ORklHX1ZJREVPX0JU
Q1g9bQpDT05GSUdfVklERU9fSVI9bQpDT05GSUdfVklERU9fVFZFRVBST009bQpDT05GSUdfVklE
RU9fVFVORVI9bQpDT05GSUdfVklERU9fQ0FQVFVSRV9EUklWRVJTPXkKQ09ORklHX1ZJREVPX0FE
Vl9ERUJVRz15CiMgQ09ORklHX1ZJREVPX0ZJWEVEX01JTk9SX1JBTkdFUyBpcyBub3Qgc2V0CkNP
TkZJR19WSURFT19IRUxQRVJfQ0hJUFNfQVVUTz15CkNPTkZJR19WSURFT19JUl9JMkM9bQpDT05G
SUdfVklERU9fV004Nzc1PW0KQ09ORklHX1ZJREVPX0NYMjM0MVg9bQojIENPTkZJR19WSURFT19W
SVZJIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQlQ4NDggaXMgbm90IHNldAojIENPTkZJR19W
SURFT19CV1FDQU0gaXMgbm90IHNldAojIENPTkZJR19WSURFT19DUUNBTSBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZJREVPX1c5OTY2IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQ1BJQSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX0NQSUEyIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fU0FBNTI0
NkEgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TQUE1MjQ5IGlzIG5vdCBzZXQKIyBDT05GSUdf
VklERU9fU1RSQURJUyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1pPUkFOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVklERU9fTUVZRSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxMzQgaXMg
bm90IHNldAojIENPTkZJR19WSURFT19NWEIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19IRVhJ
VU1fT1JJT04gaXMgbm90IHNldAojIENPTkZJR19WSURFT19IRVhJVU1fR0VNSU5JIGlzIG5vdCBz
ZXQKQ09ORklHX1ZJREVPX0NYODg9bQpDT05GSUdfVklERU9fQ1g4OF9BTFNBPW0KQ09ORklHX1ZJ
REVPX0NYODhfQkxBQ0tCSVJEPW0KQ09ORklHX1ZJREVPX0NYODhfRFZCPW0KQ09ORklHX1ZJREVP
X0NYODhfTVBFRz1tCkNPTkZJR19WSURFT19DWDg4X1ZQMzA1ND1tCiMgQ09ORklHX1ZJREVPX0NY
MjM4ODUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19BVTA4MjggaXMgbm90IHNldAojIENPTkZJ
R19WSURFT19JVlRWIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQ1gxOCBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZJREVPX0NBRkVfQ0NJQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19DQU1FUkEgaXMg
bm90IHNldAojIENPTkZJR19WNExfVVNCX0RSSVZFUlMgaXMgbm90IHNldAojIENPTkZJR19SQURJ
T19BREFQVEVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9EWU5BTUlDX01JTk9SUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RWQl9DQVBUVVJFX0RSSVZFUlMgaXMgbm90IHNldApDT05GSUdfRFZCX0NY
MjQxMjM9bQpDT05GSUdfRFZCX1NUVjAyODg9bQpDT05GSUdfRFZCX1NUQjYwMDA9bQpDT05GSUdf
RFZCX1NUVjAyOTk9bQpDT05GSUdfRFZCX0NYMjQxMTY9bQpDT05GSUdfRFZCX0NYMjI3MDI9bQpD
T05GSUdfRFZCX01UMzUyPW0KQ09ORklHX0RWQl9aTDEwMzUzPW0KQ09ORklHX0RWQl9OWFQyMDBY
PW0KQ09ORklHX0RWQl9PUjUxMTMyPW0KQ09ORklHX0RWQl9MR0RUMzMwWD1tCkNPTkZJR19EVkJf
UzVIMTQxMT1tCkNPTkZJR19EVkJfUExMPW0KQ09ORklHX0RWQl9JU0w2NDIxPW0KIyBDT05GSUdf
REFCIGlzIG5vdCBzZXQKCiMKIyBBdWRpbyBkZXZpY2VzIGZvciBtdWx0aW1lZGlhCiMKCiMKIyBB
TFNBIHNvdW5kCiMKQ09ORklHX1NORF9CVDg3WD1tCkNPTkZJR19TTkRfQlQ4N1hfT1ZFUkNMT0NL
PXkKCiMKIyBPU1Mgc291bmQKIwo=

--MP_/11lUi.R6L+435uQmUQ9kQpi--
