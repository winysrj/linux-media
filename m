Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7KAZmh5021301
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 06:35:48 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7KAZFVM032021
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 06:35:37 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1099342rvb.51
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 03:35:15 -0700 (PDT)
Message-ID: <6f278f100808200335x2dc3b973hd2248573a73990b9@mail.gmail.com>
Date: Wed, 20 Aug 2008 12:35:15 +0200
From: "Theou Jean-Baptiste" <jbtheou@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <6f278f100808180953h3a0a7f8fl55c239b825566551@mail.gmail.com>
MIME-Version: 1.0
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
	<6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
	<20080818003448.GB22438@pippin.gateway.2wire.net>
	<6f278f100808180508k792b52f5x9e945ff08466f9e6@mail.gmail.com>
	<20080818162449.GC22438@pippin.gateway.2wire.net>
	<6f278f100808180953h3a0a7f8fl55c239b825566551@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

With debug=3D4 option :


[ 2150.623457] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.623460] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70013, val: 0=D700f0
[ 2150.623463] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00013
[ 2150.623579] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D000f0
[ 2150.623704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.623953] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.623957] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.623959]
[ 2150.624079] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.624082] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.624085]
[ 2150.624204] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.624207] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.624211] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D7000d, val: 0=D70041
[ 2150.624214] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D0000d
[ 2150.624328] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00041
[ 2150.624454] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.624705] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.624709] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.624711]
[ 2150.624830] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.624833] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.624836] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D7000f, val: 0=D700c5
[ 2150.624840] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D0000f
[ 2150.624953] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D000c5
[ 2150.625079] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.625330] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.625333] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.625336]
[ 2150.625453] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.625457] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.625459]
[ 2150.625578] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.625581] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.625584] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70014, val: 0=D70011
[ 2150.625587] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00014
[ 2150.625703] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00011
[ 2150.625829] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.626078] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.626081] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.626083]
[ 2150.626202] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.626206] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.626208]
[ 2150.626327] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.626330] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.626334] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_set_led:266] led status: 1
[ 2150.626453] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D70021, data=3D0xf8f0
[ 2150.626456] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D70021, val=3D0f8f0
[ 2150.626705] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D70023, data=3D0xf802
[ 2150.626709] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D70023, val=3D0f882
[ 2150.626853] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70022, val: 0=D7007f
[ 2150.626857] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00022
[ 2150.626953] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D0007f
[ 2150.627100] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.627328] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70003
[ 2150.627473] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.627477] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 2/5
[ 2150.627479]
[ 2150.627578] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.627581] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.627584] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70023, val: 0=D70003
[ 2150.627588] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00023
[ 2150.627704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00003
[ 2150.627827] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.628078] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.628081] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.628083]
[ 2150.628206] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.628210] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.628212]
[ 2150.628328] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.628331] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.628335] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70024, val: 0=D70040
[ 2150.628338] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00024
[ 2150.628455] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00040
[ 2150.628578] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.628829] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.628833] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.628835]
[ 2150.628978] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.628981] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.628983]
[ 2150.629077] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.629080] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.629083] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70025, val: 0=D70030
[ 2150.629086] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00025
[ 2150.629201] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00030
[ 2150.629327] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.629577] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.629581] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.629583]
[ 2150.629702] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.629705] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.629707]
[ 2150.629826] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.629829] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.629832] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70026, val: 0=D700a1
[ 2150.629836] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00026
[ 2150.629952] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D000a1
[ 2150.630076] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.630326] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.630330] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.630332]
[ 2150.630452] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.630456] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.630458]
[ 2150.630576] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.630580] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.630583] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D7002a, val: 0=D70000
[ 2150.630586] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D0002a
[ 2150.630700] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00000
[ 2150.630826] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.631076] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.631079] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.631081]
[ 2150.631201] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.631204] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.631206]
[ 2150.631325] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.631329] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.631332] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D7002b, val: 0=D70000
[ 2150.631335] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D0002b
[ 2150.631450] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00000
[ 2150.631577] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.631826] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.631829] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.631831]
[ 2150.631950] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.631953] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.631955]
[ 2150.632076] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.632079] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.632083] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D7006b, val: 0=D700aa
[ 2150.632086] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D0006b
[ 2150.632200] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D000aa
[ 2150.632326] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.632576] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.632579] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.632581]
[ 2150.632701] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.632704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.632707] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70013, val: 0=D700ff
[ 2150.632710] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00013
[ 2150.632938] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D000ff
[ 2150.633075] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.633324] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.633328] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.633330]
[ 2150.633449] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.633453] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.633455]
[ 2150.633574] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.633577] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.633580] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_set_led:266] led status: 0
[ 2150.633701] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D70021, data=3D0xf8f0
[ 2150.633705] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D70021, val=3D0f8f0
[ 2150.633997] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D70023, data=3D0xf882
[ 2150.634001] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D70023, val=3D0f802
[ 2150.634075] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70090, val: 0=D70005
[ 2150.634078] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00090
[ 2150.634199] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00005
[ 2150.634323] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.634574] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.634577] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.634579]
[ 2150.634701] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.634704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.634706]
[ 2150.634825] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.634828] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.634831] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70091, val: 0=D70001
[ 2150.634835] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00091
[ 2150.634949] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00001
[ 2150.635075] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.635324] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.635327] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.635329]
[ 2150.635449] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.635452] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.635454]
[ 2150.635573] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.635576] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.635580] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70092, val: 0=D70003
[ 2150.635583] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00092
[ 2150.635699] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00003
[ 2150.635825] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.636074] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.636078] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.636080]
[ 2150.636199] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.636202] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.636205] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70093, val: 0=D70000
[ 2150.636209] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00093
[ 2150.636324] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00000
[ 2150.636449] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.636700] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.636704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.636706]
[ 2150.636823] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.636827] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.636829]
[ 2150.636948] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.636951] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.636954] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70094, val: 0=D70060
[ 2150.636957] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00094
[ 2150.637072] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00060
[ 2150.637198] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.637449] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.637452] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.637454]
[ 2150.637573] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.637576] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.637578]
[ 2150.637697] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.637700] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.637704] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70095, val: 0=D7003c
[ 2150.637707] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00095
[ 2150.637822] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D0003c
[ 2150.637947] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.638197] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.638201] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.638203]
[ 2150.638322] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.638325] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.638327]
[ 2150.638447] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.638450] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.638453] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70096, val: 0=D70024
[ 2150.638456] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00096
[ 2150.638572] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00024
[ 2150.638698] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.638948] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.638951] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.638953]
[ 2150.639072] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.639075] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.639077]
[ 2150.639197] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.639200] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.639203] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70097, val: 0=D7001e
[ 2150.639206] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00097
[ 2150.639322] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D0001e
[ 2150.639447] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.639697] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.639700] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.639702]
[ 2150.639822] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.639826] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.639828]
[ 2150.639947] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.639950] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.639954] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70098, val: 0=D70062
[ 2150.639957] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00098
[ 2150.640073] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00062
[ 2150.640197] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.640446] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007
[ 2150.640450] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0=D707, attempt 1/5
[ 2150.640452]
[ 2150.640571] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf807
[ 2150.640575] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_check_status:294] sccb status 0xf807, attempt 2/5
[ 2150.640577]
[ 2150.640696] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0xf804
[ 2150.640699] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:308] sccb_reg_write failed
[ 2150.640702] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[sccb_reg_write:302] reg: 0=D70099, val: 0=D70080
[ 2150.640705] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f2, val=3D00099
[ 2150.640821] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f3, val=3D00080
[ 2150.640946] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_write:222] reg=3D0=D700f5, val=3D00037
[ 2150.641197] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c:
[ov534_reg_read:242] reg=3D0=D700f6, data=3D0=D70007



2008/8/18 Theou Jean-Baptiste <jbtheou@gmail.com>

> Oh great ! Thanks you ;) I have send the request to my user. With debug=
=3D4
> option according to modinfo.
> I wait the result
>
> 2008/8/18 Mark Ferrell <majortrips@gmail.com>
>
> On Mon, Aug 18, 2008 at 02:08:13PM +0200, Theou Jean-Baptiste wrote:
>> > My user had meet lot of stability problem when her webcam is plug. Thi=
s
>> > problem was fixed when he unplugged her webcam. And, just after 'sudo
>> > modprobe', the blue led flash 2 sec and it's all
>> >
>> > Thanks. If you would other information, no problem
>>
>> The flashing of the LED happens during the call to ov534_setup().  After
>> that the cam shouldn't do anything unless it is opened for streaming.
>> Very verbose debug output can be enabled be loading the module with the
>> option debug=3D5.  I would be interested in the logs if possible.
>>
>> I am almost done with a cleaned up version of the driver to correct
>> unplugging the camera while it is streaming, and adding support for
>> power management. Will hopefully have something usable for more diverse
>> testing later this evening.
>>
>> --
>> Mark
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com
>> ?subject=3Dunsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
>
>
> --
> Jean-Baptiste Th=E9ou
>



--=20
Jean-Baptiste Th=E9ou
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
