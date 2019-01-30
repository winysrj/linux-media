Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0018DC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 19:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990752087F
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 19:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fy/EWrhV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbfA3TLz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 14:11:55 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:38052 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfA3TLy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 14:11:54 -0500
Received: by mail-lf1-f54.google.com with SMTP id a8so486005lfk.5
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 11:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RQ71/FsRk2pD6gIs+MFgYXGhSgOtOSQRWAYQhgrm+pg=;
        b=fy/EWrhVo5dZxxblPZOZnscX5XBJDXgzv9N/q4+jDXNs+8ycZ5WA9+JmY+VsDU6Klt
         iZn6D1rjEXY0zoORFXD6hR6arqa09hVEClPi7KykubOkyE9IK2IaA86n98/phBUbGJzQ
         smqoNX1I9yPUMnMDSLOovV1zrxkEvomDSCQTo/s/CKwbLd2+hDxF1GDnFFq5i5UhD7ja
         EqeB3an807RNMEkMStdhsLRDAA9UQSL1fgK1NdeGUhfcITi1znhM93Vxt/Q/sAg/NAY1
         0bidz1rr0toW6j5IrzyJrPAOTv9ehtIwkSFLbsIFLdIioi2mHQB0gCFjxdQ0UJ5yhGPL
         c2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RQ71/FsRk2pD6gIs+MFgYXGhSgOtOSQRWAYQhgrm+pg=;
        b=DP5cQME4JcPQXXwPakHEfvn1slzNNPATm7M41S11rMrkkuHB2sO2WCSKTbYHip/dSL
         mJuWhcGPvxxkleEvcufnIzArGwia1RloZSLFkaa40//vYwHDdQtfNMWPzZ2gRTz0+c6N
         xJU9o2w6DaC+uQyej59Y0i4NBo+QNXN3up3+CyldT1NE7ePWNQqRkN65MCHXyUcsxRZ3
         P2aauhQZllonUEPs8Ewif7X4oUGN9Ke1vLobiJ1wAtqsRFvP5Mb6Gr0i+sbRLvu/Mtby
         YoPpnWx6mV1VTATxLSp0X1dSKdE6Y9sZbSvHj8Adq41/b9Aw4F/7EJZ5RBcHhVmB2oYX
         qJHg==
X-Gm-Message-State: AJcUukdJDw4a+RHWdoQS51Hkf1yABGtmL5pF8T10Y+GsdZ4ABOqh51HX
        gyBiXb7OMLEKpLaIXPwyAxItNKGadce9ScDc3oOfkyA=
X-Google-Smtp-Source: ALg8bN5qJF/w+31NywLkqIWNfXEb1plk79BeJpilc91CuIZhiNCGECsNieD7bo/cnrFxDp4R8HwTtgrehRbVv9XFY+0=
X-Received: by 2002:a19:5e5d:: with SMTP id z29mr24008825lfi.105.1548875500523;
 Wed, 30 Jan 2019 11:11:40 -0800 (PST)
MIME-Version: 1.0
References: <af2c51da-d2d2-1f4a-b4e7-71d130afac4c@freenet.de>
In-Reply-To: <af2c51da-d2d2-1f4a-b4e7-71d130afac4c@freenet.de>
From:   Markus Rechberger <mrechberger@gmail.com>
Date:   Thu, 31 Jan 2019 03:11:28 +0800
Message-ID: <CA+O4pC+XniKwQ2Rb5-x7KDhFbqPEbPGLBnfq7fUndBdQ0tOTAw@mail.gmail.com>
Subject: Re: sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.0/usb1/1-3/dvb/dvb0.frontend0'
To:     "F.M." <moeses@freenet.de>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

our one (Sundtek) doesn't create such nodes, so this issue entirely
applies to the other device.

Best Regards,
Markus

On Thu, Jan 31, 2019 at 3:07 AM F.M. <moeses@freenet.de> wrote:
>
> Hi folks,
>
> there's an issue which only occurs with kernels 4.19+ but not with 4.9.
> Whenever the system resumes from suspend the following error message in
> the subject pops up.
>
> The two attached DVB-T/C adapters are the following:
>
> Bus 001 Device 004: ID 2659:1210 Sundtek MediaTV Pro III (EU)
> Bus 001 Device 003: ID 0b48:3014 TechnoTrend AG TT-TVStick CT2-4400
>
> The suspend is initiated by VDR and the following scripts are called
> before and after suspend:
>
> #!/bin/bash
>
> if [ "$1" =3D "pre" ]; then
>      /bin/systemctl stop vdr.service
>      /bin/systemctl stop sundtek.service
>      /bin/systemctl stop acpi-rtcwakeup.service
>      /bin/sleep 2
>      /sbin/rmmod dvb_usb_dvbsky si2168 si2157
> fi
>
> if [ "$1" =3D "post" ]; then
>      /sbin/modprobe si2157
>      /sbin/modprobe si2168
>      /sbin/modprobe dvb_usb_dvbsky
>      /bin/sleep 2
>      /bin/systemctl start acpi-rtcwakeup.service
>      /bin/systemctl start vdr.service
>      /bin/sleep 2
>      /bin/systemctl start sundtek.service
> fi
>
> I have seen someone has posted a patch some days ago but I'm not sure if
> it's the same topic.
>
> dmesg output with 4.19 and above:
>
> [Mi Jan 30 19:12:10 2019] Linux version 4.19.0-1-amd64
> (debian-kernel@lists.debian.org) (gcc version 8.2.0 (Debian 8.2.0-13))
> #1 SMP Debian 4.19.12-1 (2018-12-22)
> [Mi Jan 30 19:12:10 2019] Command line:
> BOOT_IMAGE=3D/vmlinuz-4.19.0-1-amd64 root=3D/dev/mapper/cryptvol-rootfs r=
o
> quiet splash kopt=3Droot=3D/dev/mapper/cryptvol-rootfs
> [Mi Jan 30 19:12:10 2019] x86/fpu: Supporting XSAVE feature 0x001: 'x87
> floating point registers'
> [Mi Jan 30 19:12:10 2019] x86/fpu: Supporting XSAVE feature 0x002: 'SSE
> registers'
> [Mi Jan 30 19:12:10 2019] x86/fpu: Supporting XSAVE feature 0x004: 'AVX
> registers'
> [Mi Jan 30 19:12:10 2019] x86/fpu: xstate_offset[2]:  576,
> xstate_sizes[2]:  256
> [Mi Jan 30 19:12:10 2019] x86/fpu: Enabled xstate features 0x7, context
> size is 832 bytes, using 'standard' format.
> [Mi Jan 30 19:12:10 2019] BIOS-provided physical RAM map:
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000000000000-0x000000000009c7ff] usable
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x000000000009c800-0x000000000009ffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000000e0000-0x00000000000fffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000000100000-0x000000008cf86fff] usable
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x000000008cf87000-0x000000008d45dfff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x000000008d45e000-0x0000000092289fff] usable
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x000000009228a000-0x0000000092347fff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000092348000-0x000000009236dfff] ACPI data
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x000000009236e000-0x0000000092c9dfff] ACPI NVS
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000092c9e000-0x0000000092ffefff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000092fff000-0x0000000092ffffff] usable
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000093800000-0x0000000097ffffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000f8000000-0x00000000fbffffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000fec00000-0x00000000fec00fff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000fed00000-0x00000000fed03fff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000fee00000-0x00000000fee00fff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x00000000ff000000-0x00000000ffffffff] reserved
> [Mi Jan 30 19:12:10 2019] BIOS-e820: [mem
> 0x0000000100000000-0x0000000166ffffff] usable
> [Mi Jan 30 19:12:10 2019] NX (Execute Disable) protection: active
> [Mi Jan 30 19:12:10 2019] SMBIOS 2.8 present.
> [Mi Jan 30 19:12:10 2019] DMI:  /NUC5i3RYB, BIOS
> RYBDWi35.86A.0371.2018.0709.1155 07/09/2018
> [Mi Jan 30 19:12:10 2019] tsc: Fast TSC calibration using PIT
> [Mi Jan 30 19:12:10 2019] tsc: Detected 2095.135 MHz processor
> [Mi Jan 30 19:12:10 2019] e820: update [mem 0x00000000-0x00000fff]
> usable =3D=3D> reserved
> [Mi Jan 30 19:12:10 2019] e820: remove [mem 0x000a0000-0x000fffff] usable
> [Mi Jan 30 19:12:10 2019] last_pfn =3D 0x167000 max_arch_pfn =3D 0x400000=
000
> [Mi Jan 30 19:12:10 2019] MTRR default type: uncachable
> [Mi Jan 30 19:12:10 2019] MTRR fixed ranges enabled:
> [Mi Jan 30 19:12:10 2019]   00000-9FFFF write-back
> [Mi Jan 30 19:12:10 2019]   A0000-BFFFF uncachable
> [Mi Jan 30 19:12:10 2019]   C0000-FFFFF write-protect
> [Mi Jan 30 19:12:10 2019] MTRR variable ranges enabled:
> [Mi Jan 30 19:12:10 2019]   0 base 0000000000 mask 7F80000000 write-back
> [Mi Jan 30 19:12:10 2019]   1 base 0080000000 mask 7FF0000000 write-back
> [Mi Jan 30 19:12:10 2019]   2 base 0090000000 mask 7FFE000000 write-back
> [Mi Jan 30 19:12:10 2019]   3 base 0092000000 mask 7FFF000000 write-back
> [Mi Jan 30 19:12:10 2019]   4 base 0100000000 mask 7FC0000000 write-back
> [Mi Jan 30 19:12:10 2019]   5 base 0140000000 mask 7FE0000000 write-back
> [Mi Jan 30 19:12:10 2019]   6 base 0160000000 mask 7FFC000000 write-back
> [Mi Jan 30 19:12:10 2019]   7 base 0164000000 mask 7FFE000000 write-back
> [Mi Jan 30 19:12:10 2019]   8 base 0166000000 mask 7FFF000000 write-back
> [Mi Jan 30 19:12:10 2019]   9 disabled
> [Mi Jan 30 19:12:10 2019] x86/PAT: Configuration [0-7]: WB  WC UC- UC
> WB  WP  UC- WT
> [Mi Jan 30 19:12:10 2019] e820: update [mem 0x93000000-0xffffffff]
> usable =3D=3D> reserved
> [Mi Jan 30 19:12:10 2019] last_pfn =3D 0x93000 max_arch_pfn =3D 0x4000000=
00
> [Mi Jan 30 19:12:10 2019] found SMP MP-table at [mem
> 0x000fcaf0-0x000fcaff] mapped at [(____ptrval____)]
> [Mi Jan 30 19:12:10 2019] Base memory trampoline at [(____ptrval____)]
> 96000 size 24576
> [Mi Jan 30 19:12:10 2019] Using GB pages for direct mapping
> [Mi Jan 30 19:12:10 2019] BRK [0x12d001000, 0x12d001fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d002000, 0x12d002fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d003000, 0x12d003fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d004000, 0x12d004fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d005000, 0x12d005fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d006000, 0x12d006fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d007000, 0x12d007fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d008000, 0x12d008fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d009000, 0x12d009fff] PGTABLE
> [Mi Jan 30 19:12:10 2019] BRK [0x12d00a000, 0x12d00afff] PGTABLE
> [Mi Jan 30 19:12:10 2019] RAMDISK: [mem 0x36455000-0x37221fff]
> [Mi Jan 30 19:12:10 2019] ACPI: Early table checksum verification disable=
d
> [Mi Jan 30 19:12:10 2019] ACPI: RSDP 0x00000000000F05B0 000024 (v02 INTEL=
 )
> [Mi Jan 30 19:12:10 2019] ACPI: XSDT 0x000000009234F090 00009C (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:12:10 2019] ACPI: FACP 0x0000000092365048 00010C (v05
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:12:10 2019] ACPI: DSDT 0x000000009234F1B8 015E8C (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: FACS 0x0000000092C9CF80 000040
> [Mi Jan 30 19:12:10 2019] ACPI: APIC 0x0000000092365158 000084 (v03
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:12:10 2019] ACPI: FPDT 0x00000000923651E0 000044 (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:12:10 2019] ACPI: FIDT 0x0000000092365228 00009C (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:12:10 2019] ACPI: MCFG 0x00000000923652C8 00003C (v01
> INTEL  NUC5i3RY 00000173 MSFT 00000097)
> [Mi Jan 30 19:12:10 2019] ACPI: HPET 0x0000000092365308 000038 (v01
> INTEL  NUC5i3RY 00000173 AMI. 0005000B)
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0x0000000092365340 000315 (v01
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: UEFI 0x0000000092365658 000042 (v01
> INTEL  NUC5i3RY 00000173      00000000)
> [Mi Jan 30 19:12:10 2019] ACPI: LPIT 0x00000000923656A0 000094 (v01
> INTEL  NUC5i3RY 00000173      00000000)
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0x0000000092365738 000C7D (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: ASF! 0x00000000923663B8 0000A0 (v32
> INTEL  NUC5i3RY 00000173 TFSM 000F4240)
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0x0000000092366458 000539 (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0x0000000092366998 000B74 (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0x0000000092367510 005AFE (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: DMAR 0x000000009236D010 0000D4 (v01
> INTEL  NUC5i3RY 00000173 INTL 00000001)
> [Mi Jan 30 19:12:10 2019] ACPI: Local APIC address 0xfee00000
> [Mi Jan 30 19:12:10 2019] No NUMA configuration found
> [Mi Jan 30 19:12:10 2019] Faking a node at [mem
> 0x0000000000000000-0x0000000166ffffff]
> [Mi Jan 30 19:12:10 2019] NODE_DATA(0) allocated [mem
> 0x166ffb000-0x166ffffff]
> [Mi Jan 30 19:12:10 2019] Zone ranges:
> [Mi Jan 30 19:12:10 2019]   DMA      [mem
> 0x0000000000001000-0x0000000000ffffff]
> [Mi Jan 30 19:12:10 2019]   DMA32    [mem
> 0x0000000001000000-0x00000000ffffffff]
> [Mi Jan 30 19:12:10 2019]   Normal   [mem
> 0x0000000100000000-0x0000000166ffffff]
> [Mi Jan 30 19:12:10 2019]   Device   empty
> [Mi Jan 30 19:12:10 2019] Movable zone start for each node
> [Mi Jan 30 19:12:10 2019] Early memory node ranges
> [Mi Jan 30 19:12:10 2019]   node   0: [mem
> 0x0000000000001000-0x000000000009bfff]
> [Mi Jan 30 19:12:10 2019]   node   0: [mem
> 0x0000000000100000-0x000000008cf86fff]
> [Mi Jan 30 19:12:10 2019]   node   0: [mem
> 0x000000008d45e000-0x0000000092289fff]
> [Mi Jan 30 19:12:10 2019]   node   0: [mem
> 0x0000000092fff000-0x0000000092ffffff]
> [Mi Jan 30 19:12:10 2019]   node   0: [mem
> 0x0000000100000000-0x0000000166ffffff]
> [Mi Jan 30 19:12:10 2019] Reserved but unavailable: 101 pages
> [Mi Jan 30 19:12:10 2019] Initmem setup node 0 [mem
> 0x0000000000001000-0x0000000166ffffff]
> [Mi Jan 30 19:12:10 2019] On node 0 totalpages: 1019215
> [Mi Jan 30 19:12:10 2019]   DMA zone: 64 pages used for memmap
> [Mi Jan 30 19:12:10 2019]   DMA zone: 21 pages reserved
> [Mi Jan 30 19:12:10 2019]   DMA zone: 3995 pages, LIFO batch:0
> [Mi Jan 30 19:12:10 2019]   DMA32 zone: 9271 pages used for memmap
> [Mi Jan 30 19:12:10 2019]   DMA32 zone: 593332 pages, LIFO batch:63
> [Mi Jan 30 19:12:10 2019]   Normal zone: 6592 pages used for memmap
> [Mi Jan 30 19:12:10 2019]   Normal zone: 421888 pages, LIFO batch:63
> [Mi Jan 30 19:12:10 2019] Reserving Intel graphics memory at [mem
> 0x94000000-0x97ffffff]
> [Mi Jan 30 19:12:10 2019] ACPI: PM-Timer IO Port: 0x1808
> [Mi Jan 30 19:12:10 2019] ACPI: Local APIC address 0xfee00000
> [Mi Jan 30 19:12:10 2019] ACPI: LAPIC_NMI (acpi_id[0x01] high res
> lint[0x41])
> [Mi Jan 30 19:12:10 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:12:10 2019] ACPI: LAPIC_NMI (acpi_id[0x02] dfl res lint[0x4=
1])
> [Mi Jan 30 19:12:10 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:12:10 2019] ACPI: LAPIC_NMI (acpi_id[0x03] res res lint[0xc=
f])
> [Mi Jan 30 19:12:10 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:12:10 2019] ACPI: LAPIC_NMI (acpi_id[0x04] dfl edge
> lint[0x6b])
> [Mi Jan 30 19:12:10 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:12:10 2019] IOAPIC[0]: apic_id 2, version 32, address
> 0xfec00000, GSI 0-39
> [Mi Jan 30 19:12:10 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq
> 2 dfl dfl)
> [Mi Jan 30 19:12:10 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq
> 9 high level)
> [Mi Jan 30 19:12:10 2019] ACPI: IRQ0 used by override.
> [Mi Jan 30 19:12:10 2019] ACPI: IRQ9 used by override.
> [Mi Jan 30 19:12:10 2019] Using ACPI (MADT) for SMP configuration
> information
> [Mi Jan 30 19:12:10 2019] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [Mi Jan 30 19:12:10 2019] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x00000000-0x00000fff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x0009c000-0x0009cfff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x0009d000-0x0009ffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x000a0000-0x000dffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x000e0000-0x000fffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x8cf87000-0x8d45dfff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x9228a000-0x92347fff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x92348000-0x9236dfff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x9236e000-0x92c9dfff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x92c9e000-0x92ffefff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x93000000-0x937fffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x93800000-0x97ffffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0x98000000-0xf7ffffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xf8000000-0xfbffffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfc000000-0xfebfffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfec00000-0xfec00fff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfec01000-0xfecfffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfed00000-0xfed03fff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfed04000-0xfed1bfff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfed1c000-0xfed1ffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfed20000-0xfedfffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfee00000-0xfee00fff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xfee01000-0xfeffffff]
> [Mi Jan 30 19:12:10 2019] PM: Registered nosave memory: [mem
> 0xff000000-0xffffffff]
> [Mi Jan 30 19:12:10 2019] [mem 0x98000000-0xf7ffffff] available for PCI
> devices
> [Mi Jan 30 19:12:10 2019] Booting paravirtualized kernel on bare hardware
> [Mi Jan 30 19:12:10 2019] clocksource: refined-jiffies: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
> [Mi Jan 30 19:12:10 2019] random: get_random_bytes called from
> start_kernel+0x93/0x537 with crng_init=3D0
> [Mi Jan 30 19:12:10 2019] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
> nr_cpu_ids:4 nr_node_ids:1
> [Mi Jan 30 19:12:10 2019] percpu: Embedded 44 pages/cpu
> @(____ptrval____) s143192 r8192 d28840 u524288
> [Mi Jan 30 19:12:10 2019] pcpu-alloc: s143192 r8192 d28840 u524288
> alloc=3D1*2097152
> [Mi Jan 30 19:12:10 2019] pcpu-alloc: [0] 0 1 2 3
> [Mi Jan 30 19:12:10 2019] Built 1 zonelists, mobility grouping on.
> Total pages: 1003267
> [Mi Jan 30 19:12:10 2019] Policy zone: Normal
> [Mi Jan 30 19:12:10 2019] Kernel command line:
> BOOT_IMAGE=3D/vmlinuz-4.19.0-1-amd64 root=3D/dev/mapper/cryptvol-rootfs r=
o
> quiet splash kopt=3Droot=3D/dev/mapper/cryptvol-rootfs
> [Mi Jan 30 19:12:10 2019] Calgary: detecting Calgary via BIOS EBDA area
> [Mi Jan 30 19:12:10 2019] Calgary: Unable to locate Rio Grande table in
> EBDA - bailing!
> [Mi Jan 30 19:12:10 2019] Memory: 3905676K/4076860K available (10252K
> kernel code, 1236K rwdata, 3192K rodata, 1572K init, 2332K bss, 171184K
> reserved, 0K cma-reserved)
> [Mi Jan 30 19:12:10 2019] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0=
,
> CPUs=3D4, Nodes=3D1
> [Mi Jan 30 19:12:10 2019] Kernel/User page tables isolation: enabled
> [Mi Jan 30 19:12:10 2019] ftrace: allocating 31610 entries in 124 pages
> [Mi Jan 30 19:12:10 2019] rcu: Hierarchical RCU implementation.
> [Mi Jan 30 19:12:10 2019] rcu:     RCU restricting CPUs from NR_CPUS=3D51=
2
> to nr_cpu_ids=3D4.
> [Mi Jan 30 19:12:10 2019] rcu: Adjusting geometry for
> rcu_fanout_leaf=3D16, nr_cpu_ids=3D4
> [Mi Jan 30 19:12:10 2019] NR_IRQS: 33024, nr_irqs: 728, preallocated
> irqs: 16
> [Mi Jan 30 19:12:10 2019] spurious 8259A interrupt: IRQ7.
> [Mi Jan 30 19:12:10 2019] Console: colour VGA+ 80x25
> [Mi Jan 30 19:12:10 2019] console [tty0] enabled
> [Mi Jan 30 19:12:10 2019] ACPI: Core revision 20180810
> [Mi Jan 30 19:12:10 2019] clocksource: hpet: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
> [Mi Jan 30 19:12:10 2019] hpet clockevent registered
> [Mi Jan 30 19:12:10 2019] APIC: Switch to symmetric I/O mode setup
> [Mi Jan 30 19:12:10 2019] DMAR: Host address width 39
> [Mi Jan 30 19:12:10 2019] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [Mi Jan 30 19:12:10 2019] DMAR: dmar0: reg_base_addr fed90000 ver 1:0
> cap 1c0000c40660462 ecap 7e1ff0505e
> [Mi Jan 30 19:12:10 2019] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [Mi Jan 30 19:12:10 2019] DMAR: dmar1: reg_base_addr fed91000 ver 1:0
> cap d2008c20660462 ecap f010da
> [Mi Jan 30 19:12:10 2019] DMAR: RMRR base: 0x00000092ef3000 end:
> 0x00000092f03fff
> [Mi Jan 30 19:12:10 2019] DMAR: RMRR base: 0x00000093800000 end:
> 0x00000097ffffff
> [Mi Jan 30 19:12:10 2019] DMAR: ANDD device: 2 name: \_SB.PCI0.SDHC
> [Mi Jan 30 19:12:10 2019] DMAR-IR: IOAPIC id 2 under DRHD base
> 0xfed91000 IOMMU 1
> [Mi Jan 30 19:12:10 2019] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [Mi Jan 30 19:12:10 2019] DMAR-IR: x2apic is disabled because BIOS sets
> x2apic opt out bit.
> [Mi Jan 30 19:12:10 2019] DMAR-IR: Use 'intremap=3Dno_x2apic_optout' to
> override the BIOS setting.
> [Mi Jan 30 19:12:10 2019] DMAR-IR: Enabled IRQ remapping in xapic mode
> [Mi Jan 30 19:12:10 2019] x2apic: IRQ remapping doesn't support X2APIC mo=
de
> [Mi Jan 30 19:12:10 2019] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=
=3D-1
> pin2=3D-1
> [Mi Jan 30 19:12:10 2019] clocksource: tsc-early: mask:
> 0xffffffffffffffff max_cycles: 0x1e333c9c09f, max_idle_ns: 440795226643 n=
s
> [Mi Jan 30 19:12:10 2019] Calibrating delay loop (skipped), value
> calculated using timer frequency.. 4190.27 BogoMIPS (lpj=3D8380540)
> [Mi Jan 30 19:12:10 2019] pid_max: default: 32768 minimum: 301
> [Mi Jan 30 19:12:10 2019] Security Framework initialized
> [Mi Jan 30 19:12:10 2019] Yama: disabled by default; enable with sysctl
> kernel.yama.*
> [Mi Jan 30 19:12:10 2019] AppArmor: AppArmor initialized
> [Mi Jan 30 19:12:10 2019] Dentry cache hash table entries: 524288
> (order: 10, 4194304 bytes)
> [Mi Jan 30 19:12:10 2019] Inode-cache hash table entries: 262144 (order:
> 9, 2097152 bytes)
> [Mi Jan 30 19:12:10 2019] Mount-cache hash table entries: 8192 (order:
> 4, 65536 bytes)
> [Mi Jan 30 19:12:10 2019] Mountpoint-cache hash table entries: 8192
> (order: 4, 65536 bytes)
> [Mi Jan 30 19:12:10 2019] ENERGY_PERF_BIAS: Set to 'normal', was
> 'performance'
> [Mi Jan 30 19:12:10 2019] ENERGY_PERF_BIAS: View and update with
> x86_energy_perf_policy(8)
> [Mi Jan 30 19:12:10 2019] mce: CPU supports 7 MCE banks
> [Mi Jan 30 19:12:10 2019] CPU0: Thermal monitoring enabled (TM1)
> [Mi Jan 30 19:12:10 2019] process: using mwait in idle threads
> [Mi Jan 30 19:12:10 2019] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
> [Mi Jan 30 19:12:10 2019] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0,
> 1GB 4
> [Mi Jan 30 19:12:10 2019] Spectre V2 : Mitigation: Full generic retpoline
> [Mi Jan 30 19:12:10 2019] Spectre V2 : Spectre v2 / SpectreRSB
> mitigation: Filling RSB on context switch
> [Mi Jan 30 19:12:10 2019] Spectre V2 : Enabling Restricted Speculation
> for firmware calls
> [Mi Jan 30 19:12:10 2019] Spectre V2 : mitigation: Enabling conditional
> Indirect Branch Prediction Barrier
> [Mi Jan 30 19:12:10 2019] Spectre V2 : User space: Mitigation: STIBP via
> seccomp and prctl
> [Mi Jan 30 19:12:10 2019] Speculative Store Bypass: Mitigation:
> Speculative Store Bypass disabled via prctl and seccomp
> [Mi Jan 30 19:12:10 2019] Freeing SMP alternatives memory: 24K
> [Mi Jan 30 19:12:10 2019] TSC deadline timer enabled
> [Mi Jan 30 19:12:10 2019] smpboot: CPU0: Intel(R) Core(TM) i3-5010U CPU
> @ 2.10GHz (family: 0x6, model: 0x3d, stepping: 0x4)
> [Mi Jan 30 19:12:10 2019] Performance Events: PEBS fmt2+, Broadwell
> events, 16-deep LBR, full-width counters, Intel PMU driver.
> [Mi Jan 30 19:12:10 2019] ... version:                3
> [Mi Jan 30 19:12:10 2019] ... bit width:              48
> [Mi Jan 30 19:12:10 2019] ... generic registers:      4
> [Mi Jan 30 19:12:10 2019] ... value mask: 0000ffffffffffff
> [Mi Jan 30 19:12:10 2019] ... max period: 00007fffffffffff
> [Mi Jan 30 19:12:10 2019] ... fixed-purpose events:   3
> [Mi Jan 30 19:12:10 2019] ... event mask: 000000070000000f
> [Mi Jan 30 19:12:10 2019] rcu: Hierarchical SRCU implementation.
> [Mi Jan 30 19:12:10 2019] NMI watchdog: Enabled. Permanently consumes
> one hw-PMU counter.
> [Mi Jan 30 19:12:10 2019] smp: Bringing up secondary CPUs ...
> [Mi Jan 30 19:12:10 2019] x86: Booting SMP configuration:
> [Mi Jan 30 19:12:10 2019] .... node  #0, CPUs:      #1 #2 #3
> [Mi Jan 30 19:12:10 2019] smp: Brought up 1 node, 4 CPUs
> [Mi Jan 30 19:12:10 2019] smpboot: Max logical packages: 1
> [Mi Jan 30 19:12:10 2019] smpboot: Total of 4 processors activated
> (16761.08 BogoMIPS)
> [Mi Jan 30 19:12:10 2019] devtmpfs: initialized
> [Mi Jan 30 19:12:10 2019] x86/mm: Memory block size: 128MB
> [Mi Jan 30 19:12:10 2019] PM: Registering ACPI NVS region [mem
> 0x9236e000-0x92c9dfff] (9633792 bytes)
> [Mi Jan 30 19:12:10 2019] clocksource: jiffies: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [Mi Jan 30 19:12:10 2019] futex hash table entries: 1024 (order: 4,
> 65536 bytes)
> [Mi Jan 30 19:12:10 2019] pinctrl core: initialized pinctrl subsystem
> [Mi Jan 30 19:12:10 2019] NET: Registered protocol family 16
> [Mi Jan 30 19:12:10 2019] audit: initializing netlink subsys (disabled)
> [Mi Jan 30 19:12:10 2019] audit: type=3D2000 audit(1548871930.032:1):
> state=3Dinitialized audit_enabled=3D0 res=3D1
> [Mi Jan 30 19:12:10 2019] cpuidle: using governor ladder
> [Mi Jan 30 19:12:10 2019] cpuidle: using governor menu
> [Mi Jan 30 19:12:10 2019] ACPI FADT declares the system doesn't support
> PCIe ASPM, so disable it
> [Mi Jan 30 19:12:10 2019] ACPI: bus type PCI registered
> [Mi Jan 30 19:12:10 2019] acpiphp: ACPI Hot Plug PCI Controller Driver
> version: 0.5
> [Mi Jan 30 19:12:10 2019] PCI: MMCONFIG for domain 0000 [bus 00-3f] at
> [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [Mi Jan 30 19:12:10 2019] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff]
> reserved in E820
> [Mi Jan 30 19:12:10 2019] PCI: Using configuration type 1 for base access
> [Mi Jan 30 19:12:10 2019] mtrr: your CPUs had inconsistent variable MTRR
> settings
> [Mi Jan 30 19:12:10 2019] mtrr: probably your BIOS does not setup all CPU=
s.
> [Mi Jan 30 19:12:10 2019] mtrr: corrected configuration.
> [Mi Jan 30 19:12:10 2019] HugeTLB registered 1.00 GiB page size,
> pre-allocated 0 pages
> [Mi Jan 30 19:12:10 2019] HugeTLB registered 2.00 MiB page size,
> pre-allocated 0 pages
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(Module Device)
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(Processor Device)
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(3.0 _SCP Extensions)
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(Processor Aggregator Device)
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(Linux-Dell-Video)
> [Mi Jan 30 19:12:10 2019] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
> [Mi Jan 30 19:12:10 2019] ACPI: 6 ACPI AML tables successfully acquired
> and loaded
> [Mi Jan 30 19:12:10 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0xFFFF9E47E1634800 0003D3 (v02
> PmRef  Cpu0Cst  00003001 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0xFFFF9E47E15C4800 0005AA (v02
> PmRef  ApIst    00003000 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:12:10 2019] ACPI: SSDT 0xFFFF9E47E1633C00 000119 (v02
> PmRef  ApCst    00003000 INTL 20120913)
> [Mi Jan 30 19:12:10 2019] ACPI: Interpreter enabled
> [Mi Jan 30 19:12:10 2019] ACPI: (supports S0 S3 S4 S5)
> [Mi Jan 30 19:12:10 2019] ACPI: Using IOAPIC for interrupt routing
> [Mi Jan 30 19:12:10 2019] PCI: Using host bridge windows from ACPI; if
> necessary, use "pci=3Dnocrs" and report a bug
> [Mi Jan 30 19:12:10 2019] ACPI: Enabled 7 GPEs in block 00 to 7F
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [PG00] (on)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [PG01] (on)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [PG02] (on)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [FN00] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [FN01] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [FN02] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [FN03] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: Power Resource [FN04] (off)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus
> 00-3e])
> [Mi Jan 30 19:12:10 2019] acpi PNP0A08:00: _OSC: OS supports
> [ExtendedConfig ASPM ClockPM Segments MSI]
> [Mi Jan 30 19:12:10 2019] acpi PNP0A08:00: _OSC failed (AE_ERROR);
> disabling ASPM
> [Mi Jan 30 19:12:10 2019] PCI host bridge to bus 0000:00
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [io
> 0x0000-0x0cf7 window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [io
> 0x0d00-0xffff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [mem
> 0x000a0000-0x000bffff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [mem
> 0x98000000-0xdfffffff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [mem
> 0xfe000000-0xfe113fff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: root bus resource [bus 00-3e]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:00.0: [8086:1604] type 00 class
> 0x060000
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: [8086:1616] type 00 class
> 0x030000
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: reg 0x10: [mem
> 0x99000000-0x99ffffff 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: reg 0x18: [mem
> 0xa0000000-0xbfffffff 64bit pref]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: reg 0x20: [io 0x3000-0x303f]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:03.0: [8086:160c] type 00 class
> 0x040300
> [Mi Jan 30 19:12:10 2019] pci 0000:00:03.0: reg 0x10: [mem
> 0x9a034000-0x9a037fff 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:14.0: [8086:9cb1] type 00 class
> 0x0c0330
> [Mi Jan 30 19:12:10 2019] pci 0000:00:14.0: reg 0x10: [mem
> 0x9a020000-0x9a02ffff 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:14.0: PME# supported from D3hot D3c=
old
> [Mi Jan 30 19:12:10 2019] pci 0000:00:16.0: [8086:9cba] type 00 class
> 0x078000
> [Mi Jan 30 19:12:10 2019] pci 0000:00:16.0: reg 0x10: [mem
> 0x9a03d000-0x9a03d01f 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:16.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:12:10 2019] pci 0000:00:19.0: [8086:15a3] type 00 class
> 0x020000
> [Mi Jan 30 19:12:10 2019] pci 0000:00:19.0: reg 0x10: [mem
> 0x9a000000-0x9a01ffff]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:19.0: reg 0x14: [mem
> 0x9a03b000-0x9a03bfff]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:19.0: reg 0x18: [io 0x3080-0x309f]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:19.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1b.0: [8086:9ca0] type 00 class
> 0x040300
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1b.0: reg 0x10: [mem
> 0x9a030000-0x9a033fff 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1b.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1d.0: [8086:9ca6] type 00 class
> 0x0c0320
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1d.0: reg 0x10: [mem
> 0x9a03a000-0x9a03a3ff]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1d.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.0: [8086:9cc3] type 00 class
> 0x060100
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: [8086:9c83] type 00 class
> 0x010601
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x10: [io 0x30d0-0x30d7]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x14: [io 0x30c0-0x30c3]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x18: [io 0x30b0-0x30b7]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x1c: [io 0x30a0-0x30a3]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x20: [io 0x3060-0x307f]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: reg 0x24: [mem
> 0x9a039000-0x9a0397ff]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.2: PME# supported from D3hot
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.3: [8086:9ca2] type 00 class
> 0x0c0500
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.3: reg 0x10: [mem
> 0x9a038000-0x9a0380ff 64bit]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1f.3: reg 0x20: [io 0x3040-0x305f]
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6
> 10 *11 12 14 15)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6
> 10 11 12 14 15) *0, disabled.
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6
> *10 11 12 14 15)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6
> *10 11 12 14 15)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6
> 10 11 12 14 15)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6
> 10 11 12 14 15) *0, disabled.
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6
> 10 11 12 14 15)
> [Mi Jan 30 19:12:10 2019] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6
> 10 *11 12 14 15)
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: vgaarb: setting as boot VGA
> device
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: vgaarb: VGA device added:
> decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: vgaarb: bridge control possib=
le
> [Mi Jan 30 19:12:10 2019] vgaarb: loaded
> [Mi Jan 30 19:12:10 2019] pps_core: LinuxPPS API ver. 1 registered
> [Mi Jan 30 19:12:10 2019] pps_core: Software ver. 5.3.6 - Copyright
> 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [Mi Jan 30 19:12:10 2019] PTP clock support registered
> [Mi Jan 30 19:12:10 2019] EDAC MC: Ver: 3.0.0
> [Mi Jan 30 19:12:10 2019] PCI: Using ACPI for IRQ routing
> [Mi Jan 30 19:12:10 2019] PCI: pci_cache_line_size set to 64 bytes
> [Mi Jan 30 19:12:10 2019] e820: reserve RAM buffer [mem
> 0x0009c800-0x0009ffff]
> [Mi Jan 30 19:12:10 2019] e820: reserve RAM buffer [mem
> 0x8cf87000-0x8fffffff]
> [Mi Jan 30 19:12:10 2019] e820: reserve RAM buffer [mem
> 0x9228a000-0x93ffffff]
> [Mi Jan 30 19:12:10 2019] e820: reserve RAM buffer [mem
> 0x93000000-0x93ffffff]
> [Mi Jan 30 19:12:10 2019] e820: reserve RAM buffer [mem
> 0x167000000-0x167ffffff]
> [Mi Jan 30 19:12:10 2019] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0,
> 0, 0, 0
> [Mi Jan 30 19:12:10 2019] hpet0: 8 comparators, 64-bit 14.318180 MHz coun=
ter
> [Mi Jan 30 19:12:10 2019] clocksource: Switched to clocksource tsc-early
> [Mi Jan 30 19:12:10 2019] VFS: Disk quotas dquot_6.6.0
> [Mi Jan 30 19:12:10 2019] VFS: Dquot-cache hash table entries: 512
> (order 0, 4096 bytes)
> [Mi Jan 30 19:12:10 2019] AppArmor: AppArmor Filesystem Enabled
> [Mi Jan 30 19:12:10 2019] pnp: PnP ACPI init
> [Mi Jan 30 19:12:10 2019] system 00:00: [io  0x0a00-0x0a0f] has been
> reserved
> [Mi Jan 30 19:12:10 2019] system 00:00: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:12:10 2019] pnp 00:01: Plug and Play ACPI device, IDs
> NTN0530 (active)
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0x0680-0x069f] has been
> reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0x1800-0x18fe] has been
> reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: [io  0x164e-0x164f] has been
> reserved
> [Mi Jan 30 19:12:10 2019] system 00:02: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:12:10 2019] pnp 00:03: Plug and Play ACPI device, IDs
> PNP0b00 (active)
> [Mi Jan 30 19:12:10 2019] system 00:04: [io  0x1854-0x1857] has been
> reserved
> [Mi Jan 30 19:12:10 2019] system 00:04: Plug and Play ACPI device, IDs
> INT3f0d PNP0c02 (active)
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed1c000-0xfed1ffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed10000-0xfed17fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed18000-0xfed18fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed19000-0xfed19fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xf8000000-0xfbffffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed20000-0xfed3ffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed90000-0xfed93fff]
> could not be reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfed45000-0xfed8ffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xff000000-0xffffffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0xfee00000-0xfeefffff]
> could not be reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0x98010000-0x9801ffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: [mem 0x98000000-0x9800ffff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:05: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:12:10 2019] system 00:06: [mem 0xfe104000-0xfe104fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:06: [mem 0xfe106000-0xfe106fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:06: [mem 0xfe112000-0xfe112fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:06: [mem 0xfe111000-0xfe111007] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:06: [mem 0xfe111014-0xfe111fff] has
> been reserved
> [Mi Jan 30 19:12:10 2019] system 00:06: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:12:10 2019] pnp: PnP ACPI: found 7 devices
> [Mi Jan 30 19:12:10 2019] clocksource: acpi_pm: mask: 0xffffff
> max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: resource 4 [io 0x0000-0x0cf7
> window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: resource 5 [io 0x0d00-0xffff
> window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: resource 6 [mem
> 0x000a0000-0x000bffff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: resource 7 [mem
> 0x98000000-0xdfffffff window]
> [Mi Jan 30 19:12:10 2019] pci_bus 0000:00: resource 8 [mem
> 0xfe000000-0xfe113fff window]
> [Mi Jan 30 19:12:10 2019] NET: Registered protocol family 2
> [Mi Jan 30 19:12:10 2019] tcp_listen_portaddr_hash hash table entries:
> 2048 (order: 3, 32768 bytes)
> [Mi Jan 30 19:12:10 2019] TCP established hash table entries: 32768
> (order: 6, 262144 bytes)
> [Mi Jan 30 19:12:10 2019] TCP bind hash table entries: 32768 (order: 7,
> 524288 bytes)
> [Mi Jan 30 19:12:10 2019] TCP: Hash tables configured (established 32768
> bind 32768)
> [Mi Jan 30 19:12:10 2019] UDP hash table entries: 2048 (order: 4, 65536
> bytes)
> [Mi Jan 30 19:12:10 2019] UDP-Lite hash table entries: 2048 (order: 4,
> 65536 bytes)
> [Mi Jan 30 19:12:10 2019] NET: Registered protocol family 1
> [Mi Jan 30 19:12:10 2019] pci 0000:00:02.0: Video device with shadowed
> ROM at [mem 0x000c0000-0x000dffff]
> [Mi Jan 30 19:12:10 2019] pci 0000:00:1d.0:
> quirk_usb_early_handoff+0x0/0x6c3 took 21723 usecs
> [Mi Jan 30 19:12:10 2019] PCI: CLS 0 bytes, default 64
> [Mi Jan 30 19:12:10 2019] Unpacking initramfs...
> [Mi Jan 30 19:12:10 2019] Freeing initrd memory: 14132K
> [Mi Jan 30 19:12:10 2019] DMAR: ACPI device "INT3436:00" under DMAR at
> fed91000 as 00:17.0
> [Mi Jan 30 19:12:10 2019] PCI-DMA: Using software bounce buffering for
> IO (SWIOTLB)
> [Mi Jan 30 19:12:10 2019] software IO TLB: mapped [mem
> 0x8e28a000-0x9228a000] (64MB)
> [Mi Jan 30 19:12:10 2019] Initialise system trusted keyrings
> [Mi Jan 30 19:12:10 2019] workingset: timestamp_bits=3D40 max_order=3D20
> bucket_order=3D0
> [Mi Jan 30 19:12:10 2019] zbud: loaded
> [Mi Jan 30 19:12:10 2019] pstore: using deflate compression
> [Mi Jan 30 19:12:10 2019] Key type asymmetric registered
> [Mi Jan 30 19:12:10 2019] Asymmetric key parser 'x509' registered
> [Mi Jan 30 19:12:10 2019] Block layer SCSI generic (bsg) driver version
> 0.4 loaded (major 247)
> [Mi Jan 30 19:12:10 2019] io scheduler noop registered
> [Mi Jan 30 19:12:10 2019] io scheduler deadline registered
> [Mi Jan 30 19:12:10 2019] io scheduler cfq registered (default)
> [Mi Jan 30 19:12:10 2019] io scheduler mq-deadline registered
> [Mi Jan 30 19:12:10 2019] shpchp: Standard Hot Plug PCI Controller
> Driver version: 0.4
> [Mi Jan 30 19:12:10 2019] intel_idle: MWAIT substates: 0x11142120
> [Mi Jan 30 19:12:10 2019] intel_idle: v0.4.1 model 0x3D
> [Mi Jan 30 19:12:10 2019] intel_idle: lapic_timer_reliable_states 0xfffff=
fff
> [Mi Jan 30 19:12:10 2019] Serial: 8250/16550 driver, 4 ports, IRQ
> sharing enabled
> [Mi Jan 30 19:12:10 2019] Linux agpgart interface v0.103
> [Mi Jan 30 19:12:10 2019] AMD IOMMUv2 driver by Joerg Roedel
> <jroedel@suse.de>
> [Mi Jan 30 19:12:10 2019] AMD IOMMUv2 functionality not available on
> this system
> [Mi Jan 30 19:12:10 2019] i8042: PNP: No PS/2 controller found.
> [Mi Jan 30 19:12:10 2019] mousedev: PS/2 mouse device common for all mice
> [Mi Jan 30 19:12:10 2019] rtc_cmos 00:03: RTC can wake from S4
> [Mi Jan 30 19:12:10 2019] rtc_cmos 00:03: registered as rtc0
> [Mi Jan 30 19:12:10 2019] rtc_cmos 00:03: alarms up to one month, y3k,
> 242 bytes nvram, hpet irqs
> [Mi Jan 30 19:12:10 2019] intel_pstate: Intel P-state driver initializing
> [Mi Jan 30 19:12:10 2019] ledtrig-cpu: registered to indicate activity
> on CPUs
> [Mi Jan 30 19:12:10 2019] NET: Registered protocol family 10
> [Mi Jan 30 19:12:10 2019] Segment Routing with IPv6
> [Mi Jan 30 19:12:10 2019] mip6: Mobile IPv6
> [Mi Jan 30 19:12:10 2019] NET: Registered protocol family 17
> [Mi Jan 30 19:12:10 2019] mpls_gso: MPLS GSO support
> [Mi Jan 30 19:12:10 2019] microcode: sig=3D0x306d4, pf=3D0x40, revision=
=3D0x2b
> [Mi Jan 30 19:12:10 2019] microcode: Microcode Update Driver: v2.2.
> [Mi Jan 30 19:12:10 2019] sched_clock: Marking stable (784028275,
> 2148097)->(789282080, -3105708)
> [Mi Jan 30 19:12:10 2019] registered taskstats version 1
> [Mi Jan 30 19:12:10 2019] Loading compiled-in X.509 certificates
> [Mi Jan 30 19:12:10 2019] Loaded X.509 cert
> 'secure-boot-test-key-lfaraone: 97c1b25cddf9873ca78a58f3d73bf727d2cf78ff'
> [Mi Jan 30 19:12:10 2019] zswap: loaded using pool lzo/zbud
> [Mi Jan 30 19:12:10 2019] AppArmor: AppArmor sha1 policy hashing enabled
> [Mi Jan 30 19:12:10 2019] rtc_cmos 00:03: setting system clock to
> 2019-01-30 18:12:11 UTC (1548871931)
> [Mi Jan 30 19:12:11 2019] Freeing unused kernel image memory: 1572K
> [Mi Jan 30 19:12:11 2019] Write protecting the kernel read-only data: 163=
84k
> [Mi Jan 30 19:12:11 2019] Freeing unused kernel image memory: 2028K
> [Mi Jan 30 19:12:11 2019] Freeing unused kernel image memory: 904K
> [Mi Jan 30 19:12:11 2019] x86/mm: Checked W+X mappings: passed, no W+X
> pages found.
> [Mi Jan 30 19:12:11 2019] x86/mm: Checking user space page tables
> [Mi Jan 30 19:12:11 2019] x86/mm: Checked W+X mappings: passed, no W+X
> pages found.
> [Mi Jan 30 19:12:11 2019] Run /init as init process
> [Mi Jan 30 19:12:11 2019] input: Sleep Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
> [Mi Jan 30 19:12:11 2019] ACPI: Sleep Button [SLPB]
> [Mi Jan 30 19:12:11 2019] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> [Mi Jan 30 19:12:11 2019] ACPI: Power Button [PWRB]
> [Mi Jan 30 19:12:11 2019] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [Mi Jan 30 19:12:11 2019] ACPI: Power Button [PWRF]
> [Mi Jan 30 19:12:11 2019] thermal LNXTHERM:00: registered as thermal_zone=
0
> [Mi Jan 30 19:12:11 2019] ACPI: Thermal Zone [TZ00] (28 C)
> [Mi Jan 30 19:12:11 2019] thermal LNXTHERM:01: registered as thermal_zone=
1
> [Mi Jan 30 19:12:11 2019] ACPI: Thermal Zone [TZ01] (30 C)
> [Mi Jan 30 19:12:11 2019] ACPI: bus type USB registered
> [Mi Jan 30 19:12:11 2019] usbcore: registered new interface driver usbfs
> [Mi Jan 30 19:12:11 2019] usbcore: registered new interface driver hub
> [Mi Jan 30 19:12:11 2019] usbcore: registered new device driver usb
> [Mi Jan 30 19:12:11 2019] SCSI subsystem initialized
> [Mi Jan 30 19:12:11 2019] cryptd: max_cpu_qlen set to 1000
> [Mi Jan 30 19:12:11 2019] libata version 3.00 loaded.
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: new USB bus registered,
> assigned bus number 1
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: hcc params 0x200077c1
> hci version 0x100 quirks 0x000000000004b810
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: cache line size of 64
> is not supported
> [Mi Jan 30 19:12:11 2019] usb usb1: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0002, bcdDevice=3D 4.19
> [Mi Jan 30 19:12:11 2019] usb usb1: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:12:11 2019] usb usb1: Product: xHCI Host Controller
> [Mi Jan 30 19:12:11 2019] usb usb1: Manufacturer: Linux 4.19.0-1-amd64
> xhci-hcd
> [Mi Jan 30 19:12:11 2019] usb usb1: SerialNumber: 0000:00:14.0
> [Mi Jan 30 19:12:11 2019] hub 1-0:1.0: USB hub found
> [Mi Jan 30 19:12:11 2019] hub 1-0:1.0: 11 ports detected
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: new USB bus registered,
> assigned bus number 2
> [Mi Jan 30 19:12:11 2019] xhci_hcd 0000:00:14.0: Host supports USB 3.0
> SuperSpeed
> [Mi Jan 30 19:12:11 2019] usb usb2: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0003, bcdDevice=3D 4.19
> [Mi Jan 30 19:12:11 2019] usb usb2: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:12:11 2019] usb usb2: Product: xHCI Host Controller
> [Mi Jan 30 19:12:11 2019] usb usb2: Manufacturer: Linux 4.19.0-1-amd64
> xhci-hcd
> [Mi Jan 30 19:12:11 2019] usb usb2: SerialNumber: 0000:00:14.0
> [Mi Jan 30 19:12:11 2019] hub 2-0:1.0: USB hub found
> [Mi Jan 30 19:12:11 2019] hub 2-0:1.0: 4 ports detected
> [Mi Jan 30 19:12:11 2019] AVX2 version of gcm_enc/dec engaged.
> [Mi Jan 30 19:12:11 2019] AES CTR mode by8 optimization enabled
> [Mi Jan 30 19:12:11 2019] ahci 0000:00:1f.2: version 3.0
> [Mi Jan 30 19:12:11 2019] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4
> ports 6 Gbps 0x1 impl SATA mode
> [Mi Jan 30 19:12:11 2019] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo
> only pio slum part deso sadm sds apst
> [Mi Jan 30 19:12:11 2019] scsi host0: ahci
> [Mi Jan 30 19:12:11 2019] scsi host1: ahci
> [Mi Jan 30 19:12:11 2019] scsi host2: ahci
> [Mi Jan 30 19:12:11 2019] scsi host3: ahci
> [Mi Jan 30 19:12:11 2019] ata1: SATA max UDMA/133 abar m2048@0x9a039000
> port 0x9a039100 irq 43
> [Mi Jan 30 19:12:11 2019] ata2: DUMMY
> [Mi Jan 30 19:12:11 2019] ata3: DUMMY
> [Mi Jan 30 19:12:11 2019] ata4: DUMMY
> [Mi Jan 30 19:12:11 2019] [drm] Replacing VGA console driver
> [Mi Jan 30 19:12:11 2019] Console: switching to colour dummy device 80x25
> [Mi Jan 30 19:12:11 2019] [drm] Supports vblank timestamp caching Rev 2
> (21.10.2013).
> [Mi Jan 30 19:12:11 2019] [drm] Driver supports precise vblank timestamp
> query.
> [Mi Jan 30 19:12:11 2019] i915 0000:00:02.0: vgaarb: changed VGA
> decodes: olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> [Mi Jan 30 19:12:11 2019] random: fast init done
> [Mi Jan 30 19:12:11 2019] [drm] Initialized i915 1.6.0 20180719 for
> 0000:00:02.0 on minor 0
> [Mi Jan 30 19:12:11 2019] ACPI: Video Device [GFX0] (multi-head: yes
> rom: no  post: no)
> [Mi Jan 30 19:12:11 2019] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> [Mi Jan 30 19:12:11 2019] fbcon: inteldrmfb (fb0) is primary device
> [Mi Jan 30 19:12:11 2019] tsc: Refined TSC clocksource calibration:
> 2095.151 MHz
> [Mi Jan 30 19:12:11 2019] clocksource: tsc: mask: 0xffffffffffffffff
> max_cycles: 0x1e334bf9478, max_idle_ns: 440795246703 ns
> [Mi Jan 30 19:12:11 2019] clocksource: Switched to clocksource tsc
> [Mi Jan 30 19:12:11 2019] Console: switching to colour frame buffer
> device 240x67
> [Mi Jan 30 19:12:11 2019] i915 0000:00:02.0: fb0: inteldrmfb frame
> buffer device
> [Mi Jan 30 19:12:11 2019] usb 1-2: new full-speed USB device number 2
> using xhci_hcd
> [Mi Jan 30 19:12:11 2019] ata1: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> [Mi Jan 30 19:12:11 2019] ata1.00: ATA-10: ST2000LX001-1RG174, SDM1, max
> UDMA/133
> [Mi Jan 30 19:12:11 2019] ata1.00: 3907029168 sectors, multi 16: LBA48
> NCQ (depth 32), AA
> [Mi Jan 30 19:12:11 2019] usb 1-2: New USB device found, idVendor=3D046d,
> idProduct=3Dc52b, bcdDevice=3D24.01
> [Mi Jan 30 19:12:11 2019] usb 1-2: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D0
> [Mi Jan 30 19:12:11 2019] usb 1-2: Product: USB Receiver
> [Mi Jan 30 19:12:11 2019] usb 1-2: Manufacturer: Logitech
> [Mi Jan 30 19:12:11 2019] ata1.00: configured for UDMA/133
> [Mi Jan 30 19:12:11 2019] scsi 0:0:0:0: Direct-Access     ATA
> ST2000LX001-1RG1 SDM1 PQ: 0 ANSI: 5
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] 3907029168 512-byte logical
> blocks: (2.00 TB/1.82 TiB)
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] Write Protect is off
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> [Mi Jan 30 19:12:11 2019]  sda: sda1 sda2 < sda5 > sda3 sda4
> [Mi Jan 30 19:12:11 2019] sd 0:0:0:0: [sda] Attached SCSI disk
> [Mi Jan 30 19:12:11 2019] usb 1-3: new high-speed USB device number 3
> using xhci_hcd
> [Mi Jan 30 19:12:12 2019] usb 1-3: New USB device found, idVendor=3D0b48,
> idProduct=3D3014, bcdDevice=3D 0.00
> [Mi Jan 30 19:12:12 2019] usb 1-3: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D3
> [Mi Jan 30 19:12:12 2019] usb 1-3: Product: TechnoTrend USB-Stick
> [Mi Jan 30 19:12:12 2019] usb 1-3: Manufacturer: CityCom GmbH
> [Mi Jan 30 19:12:12 2019] usb 1-3: SerialNumber: 20131128
> [Mi Jan 30 19:12:12 2019] usb 1-4: new high-speed USB device number 4
> using xhci_hcd
> [Mi Jan 30 19:12:12 2019] usb 1-4: New USB device found, idVendor=3D2659,
> idProduct=3D1210, bcdDevice=3D40.01
> [Mi Jan 30 19:12:12 2019] usb 1-4: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D3
> [Mi Jan 30 19:12:12 2019] usb 1-4: Product: MediaTV Pro III (EU)
> [Mi Jan 30 19:12:12 2019] usb 1-4: Manufacturer: Sundtek
> [Mi Jan 30 19:12:12 2019] usb 1-4: SerialNumber: U150624171804
> [Mi Jan 30 19:12:12 2019] hidraw: raw HID events driver (C) Jiri Kosina
> [Mi Jan 30 19:12:12 2019] usbcore: registered new interface driver usbhid
> [Mi Jan 30 19:12:12 2019] usbhid: USB HID core driver
> [Mi Jan 30 19:12:12 2019] logitech-djreceiver 0003:046D:C52B.0003:
> hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:14.0-2/input2
> [Mi Jan 30 19:12:12 2019] input: Logitech Unifying Device. Wireless
> PID:404d Keyboard as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input4
> [Mi Jan 30 19:12:12 2019] input: Logitech Unifying Device. Wireless
> PID:404d Mouse as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input5
> [Mi Jan 30 19:12:12 2019] input: Logitech Unifying Device. Wireless
> PID:404d Consumer Control as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input6
> [Mi Jan 30 19:12:12 2019] input: Logitech Unifying Device. Wireless
> PID:404d System Control as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input7
> [Mi Jan 30 19:12:12 2019] hid-generic 0003:046D:404D.0004:
> input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device.
> Wireless PID:404d] on usb-0000:00:14.0-2:1
> [Mi Jan 30 19:12:12 2019] device-mapper: uevent: version 1.0.3
> [Mi Jan 30 19:12:12 2019] device-mapper: ioctl: 4.39.0-ioctl
> (2018-04-03) initialised: dm-devel@redhat.com
> [Mi Jan 30 19:12:12 2019] random: lvm: uninitialized urandom read (4
> bytes read)
> [Mi Jan 30 19:12:12 2019] random: lvm: uninitialized urandom read (4
> bytes read)
> [Mi Jan 30 19:12:13 2019] input: Logitech K400 Plus as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input11
> [Mi Jan 30 19:12:13 2019] logitech-hidpp-device 0003:046D:404D.0004:
> input,hidraw1: USB HID v1.11 Keyboard [Logitech K400 Plus] on
> usb-0000:00:14.0-2:1
> [Mi Jan 30 19:12:18 2019] random: crng init done
> [Mi Jan 30 19:12:19 2019] PM: Image not found (code -22)
> [Mi Jan 30 19:12:20 2019] EXT4-fs (dm-1): mounted filesystem with
> ordered data mode. Opts: (null)
> [Mi Jan 30 19:12:24 2019] systemd[1]: Inserted module 'autofs4'
> [Mi Jan 30 19:12:24 2019] systemd[1]: systemd 240 running in system
> mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP
> +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS
> +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=3Dhybrid)
> [Mi Jan 30 19:12:24 2019] systemd[1]: Detected architecture x86-64.
> [Mi Jan 30 19:12:24 2019] systemd[1]: Set hostname to <media-box>.
> [Mi Jan 30 19:12:25 2019] systemd[1]:
> /lib/systemd/system/smbd.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/samba/smbd.pid =E2=86=92
> /run/samba/smbd.pid; please update the unit file accordingly.
> [Mi Jan 30 19:12:25 2019] systemd[1]:
> /lib/systemd/system/nmbd.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/samba/nmbd.pid =E2=86=92
> /run/samba/nmbd.pid; please update the unit file accordingly.
> [Mi Jan 30 19:12:25 2019] systemd[1]:
> /lib/systemd/system/dovecot.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/dovecot/master.pid =E2=86=
=92
> /run/dovecot/master.pid; please update the unit file accordingly.
> [Mi Jan 30 19:12:25 2019] systemd[1]: Listening on Journal Socket.
> [Mi Jan 30 19:12:25 2019] systemd[1]: Listening on udev Kernel Socket.
> [Mi Jan 30 19:12:25 2019] systemd[1]: Listening on Journal Audit Socket.
> [Mi Jan 30 19:12:25 2019] systemd[1]: Created slice system-getty.slice.
> [Mi Jan 30 19:12:26 2019] EXT4-fs (dm-1): re-mounted. Opts:
> errors=3Dremount-ro
> [Mi Jan 30 19:12:26 2019] systemd-journald[351]: Received request to
> flush runtime journal from PID 1
> [Mi Jan 30 19:12:27 2019] ehci_hcd: USB 2.0 'Enhanced' Host Controller
> (EHCI) Driver
> [Mi Jan 30 19:12:27 2019] RPC: Registered named UNIX socket transport
> module.
> [Mi Jan 30 19:12:27 2019] RPC: Registered udp transport module.
> [Mi Jan 30 19:12:27 2019] RPC: Registered tcp transport module.
> [Mi Jan 30 19:12:27 2019] RPC: Registered tcp NFSv4.1 backchannel
> transport module.
> [Mi Jan 30 19:12:27 2019] ehci-pci: EHCI PCI platform driver
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: new USB bus registered,
> assigned bus number 3
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: debug port 2
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: cache line size of 64
> is not supported
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: irq 23, io mem 0x9a03a00=
0
> [Mi Jan 30 19:12:27 2019] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.=
00
> [Mi Jan 30 19:12:27 2019] usb usb3: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0002, bcdDevice=3D 4.19
> [Mi Jan 30 19:12:27 2019] usb usb3: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:12:27 2019] usb usb3: Product: EHCI Host Controller
> [Mi Jan 30 19:12:27 2019] usb usb3: Manufacturer: Linux 4.19.0-1-amd64
> ehci_hcd
> [Mi Jan 30 19:12:27 2019] usb usb3: SerialNumber: 0000:00:1d.0
> [Mi Jan 30 19:12:27 2019] hub 3-0:1.0: USB hub found
> [Mi Jan 30 19:12:27 2019] hub 3-0:1.0: 2 ports detected
> [Mi Jan 30 19:12:27 2019] Installing knfsd (copyright (C) 1996
> okir@monad.swb.de).
> [Mi Jan 30 19:12:27 2019] usb 3-1: new high-speed USB device number 2
> using ehci-pci
> [Mi Jan 30 19:12:27 2019] usb 3-1: New USB device found, idVendor=3D8087,
> idProduct=3D8001, bcdDevice=3D 0.03
> [Mi Jan 30 19:12:27 2019] usb 3-1: New USB device strings: Mfr=3D0,
> Product=3D0, SerialNumber=3D0
> [Mi Jan 30 19:12:27 2019] hub 3-1:1.0: USB hub found
> [Mi Jan 30 19:12:27 2019] hub 3-1:1.0: 8 ports detected
> [Mi Jan 30 19:12:29 2019] input: PC Speaker as
> /devices/platform/pcspkr/input/input12
> [Mi Jan 30 19:12:29 2019] RAPL PMU: API unit is 2^-32 Joules, 4 fixed
> counters, 655360 ms ovfl timer
> [Mi Jan 30 19:12:29 2019] RAPL PMU: hw unit of domain pp0-core 2^-14 Joul=
es
> [Mi Jan 30 19:12:29 2019] RAPL PMU: hw unit of domain package 2^-14 Joule=
s
> [Mi Jan 30 19:12:29 2019] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [Mi Jan 30 19:12:29 2019] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joule=
s
> [Mi Jan 30 19:12:29 2019] Adding 4194300k swap on
> /dev/mapper/cryptvol-swap.  Priority:-2 extents:1 across:4194300k FS
> [Mi Jan 30 19:12:29 2019] i801_smbus 0000:00:1f.3: SPD Write Disable is s=
et
> [Mi Jan 30 19:12:29 2019] i801_smbus 0000:00:1f.3: SMBus using PCI interr=
upt
> [Mi Jan 30 19:12:29 2019] iTCO_vendor_support: vendor-support=3D0
> [Mi Jan 30 19:12:29 2019] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [Mi Jan 30 19:12:29 2019] iTCO_wdt: Found a Wildcat Point_LP TCO device
> (Version=3D2, TCOBASE=3D0x1860)
> [Mi Jan 30 19:12:29 2019] iTCO_wdt: initialized. heartbeat=3D30 sec
> (nowayout=3D0)
> [Mi Jan 30 19:12:29 2019] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [Mi Jan 30 19:12:29 2019] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.=
6-k
> [Mi Jan 30 19:12:29 2019] e1000e: Copyright(c) 1999 - 2015 Intel
> Corporation.
> [Mi Jan 30 19:12:29 2019] e1000e 0000:00:19.0: Interrupt Throttling Rate
> (ints/sec) set to dynamic conservative mode
> [Mi Jan 30 19:12:29 2019] e1000e 0000:00:19.0 0000:00:19.0
> (uninitialized): registered PHC clock
> [Mi Jan 30 19:12:29 2019] e1000e 0000:00:19.0 eth0: (PCI
> Express:2.5GT/s:Width x1) b8:ae:ed:72:db:9c
> [Mi Jan 30 19:12:29 2019] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000
> Network Connection
> [Mi Jan 30 19:12:29 2019] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12,
> PBA No: FFFFFF-0FF
> [Mi Jan 30 19:12:30 2019] nuvoton-cir 00:01: found NCT6776F or
> compatible: chip id: 0xc3 0x33
> [Mi Jan 30 19:12:30 2019] e1000e 0000:00:19.0 enp0s25: renamed from eth0
> [Mi Jan 30 19:12:30 2019] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0
> (ops i915_audio_component_bind_ops [i915])
> [Mi Jan 30 19:12:30 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D3 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input14
> [Mi Jan 30 19:12:30 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D7 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input15
> [Mi Jan 30 19:12:30 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D8 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input16
> [Mi Jan 30 19:12:30 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D9 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input17
> [Mi Jan 30 19:12:30 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D10 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input18
> [Mi Jan 30 19:12:30 2019] snd_hda_intel 0000:00:03.0: device 8086:2057
> is on the power_save blacklist, forcing power_save to 0
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0: autoconfig
> for ALC283: line_outs=3D1 (0x21/0x0/0x0/0x0/0x0) type:hp
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0:
> speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0: hp_outs=3D0
> (0x0/0x0/0x0/0x0/0x0)
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0: mono:
> mono_out=3D0x0
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0: inputs:
> [Mi Jan 30 19:12:30 2019] snd_hda_codec_realtek hdaudioC1D0: Mic=3D0x19
> [Mi Jan 30 19:12:30 2019] input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input19
> [Mi Jan 30 19:12:30 2019] input: HDA Intel PCH Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input20
> [Mi Jan 30 19:12:30 2019] input: HDA Intel PCH Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input21
> [Mi Jan 30 19:12:30 2019] snd_hda_intel 0000:00:1b.0: device 8086:2057
> is on the power_save blacklist, forcing power_save to 0
> [Mi Jan 30 19:12:30 2019] Registered IR keymap rc-rc6-mce
> [Mi Jan 30 19:12:30 2019] IR RC6 protocol handler initialized
> [Mi Jan 30 19:12:30 2019] rc rc0: Nuvoton w836x7hg Infrared Remote
> Transceiver as /devices/pnp0/00:01/rc/rc0
> [Mi Jan 30 19:12:30 2019] input: Nuvoton w836x7hg Infrared Remote
> Transceiver as /devices/pnp0/00:01/rc/rc0/input13
> [Mi Jan 30 19:12:30 2019] rc rc0: lirc_dev: driver nuvoton-cir
> registered at minor =3D 0, raw IR receiver, no transmitter
> [Mi Jan 30 19:12:30 2019] nuvoton-cir 00:01: driver has been
> successfully loaded
> [Mi Jan 30 19:12:31 2019] intel_rapl: Found RAPL domain package
> [Mi Jan 30 19:12:31 2019] intel_rapl: Found RAPL domain core
> [Mi Jan 30 19:12:31 2019] intel_rapl: Found RAPL domain uncore
> [Mi Jan 30 19:12:31 2019] intel_rapl: Found RAPL domain dram
> [Mi Jan 30 19:12:31 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend
> TVStick CT2-4400' in warm state
> [Mi Jan 30 19:12:31 2019] usb 1-3: dvb_usb_v2: will pass the complete
> MPEG2 transport stream to the software demuxer
> [Mi Jan 30 19:12:31 2019] dvbdev: DVB: registering new adapter
> (TechnoTrend TVStick CT2-4400)
> [Mi Jan 30 19:12:31 2019] usb 1-3: dvb_usb_v2: MAC address:
> bc:ea:2b:44:0f:89
> [Mi Jan 30 19:12:32 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan 30 19:12:32 2019] si2168 6-0064: Silicon Labs Si2168-B40
> successfully identified
> [Mi Jan 30 19:12:32 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan 30 19:12:32 2019] media: Linux media interface: v0.10
> [Mi Jan 30 19:12:33 2019] si2157 7-0060: Silicon Labs
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan 30 19:12:33 2019] usb 1-3: DVB: registering adapter 0 frontend 0
> (Silicon Labs Si2168)...
> [Mi Jan 30 19:12:33 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick
> CT2-4400' successfully initialized and connected
> [Mi Jan 30 19:12:33 2019] usbcore: registered new interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:12:38 2019] EXT4-fs (sda1): mounted filesystem with
> ordered data mode. Opts: (null)
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.289:2):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"/usr/bin/man" pid=3D558 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.289:3):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"man_filter" pid=3D558 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.289:4):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"man_groff" pid=3D558 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.293:5):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"libreoffice-xpdfimport" pid=3D560 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.313:6):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"libreoffice-senddoc" pid=3D561 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.325:7):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"libreoffice-oopslash" pid=3D559 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.437:8):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"/usr/lib/x86_64-linux-gnu/lightdm/lightdm-guest-session" pid=3D55=
6
> comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:39 2019] audit: type=3D1400 audit(1548871960.437:9):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"/usr/lib/x86_64-linux-gnu/lightdm/lightdm-guest-session//chromium=
"
> pid=3D556 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:46 2019] audit: type=3D1400 audit(1548871966.681:10):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"libreoffice-soffice" pid=3D557 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:46 2019] audit: type=3D1400 audit(1548871966.685:11):
> apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"
> name=3D"libreoffice-soffice//gpg" pid=3D557 comm=3D"apparmor_parser"
> [Mi Jan 30 19:12:46 2019] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is
> not ready
> [Mi Jan 30 19:12:49 2019] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full
> Duplex, Flow Control: Rx/Tx
> [Mi Jan 30 19:12:49 2019] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: link
> becomes ready
> [Mi Jan 30 19:12:52 2019] NFSD: Using /var/lib/nfs/v4recovery as the
> NFSv4 state recovery directory
> [Mi Jan 30 19:12:52 2019] NFSD: starting 45-second grace period (net
> f00000a8)
> [Mi Jan 30 19:12:52 2019] input: Sundtek Remote Control as
> /devices/virtual/input/input22
> [Mi Jan 30 19:13:00 2019] si2168 6-0064: firmware: direct-loading
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan 30 19:13:00 2019] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan 30 19:13:01 2019] si2168 6-0064: firmware version: B 4.0.11
> [Mi Jan 30 19:13:01 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30=
'
> [Mi Jan 30 19:13:01 2019] si2157 7-0060: firmware version: 3.0.5
> [Mi Jan 30 19:13:04 2019] fuse init (API version 7.27)
> [Mi Jan 30 19:13:58 2019] usb 1-4: usbfs: process 805 (mediasrv) did not
> claim interface 2 before use
> [Mi Jan 30 19:14:17 2019] SGI XFS with ACLs, security attributes,
> realtime, no debug enabled
> [Mi Jan 30 19:14:17 2019] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
> [Mi Jan 30 19:14:17 2019] ntfs: driver 2.1.32 [Flags: R/O MODULE].
> [Mi Jan 30 19:14:17 2019] QNX4 filesystem 0.2.3 registered.
> [Mi Jan 30 19:14:17 2019] raid6: sse2x1   gen()  6812 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: sse2x1   xor()  4844 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: sse2x2   gen()  8159 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: sse2x2   xor()  5291 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: sse2x4   gen()  9822 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: sse2x4   xor()  6018 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: avx2x1   gen() 13721 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: avx2x1   xor()  9044 MB/s
> [Mi Jan 30 19:14:17 2019] raid6: avx2x2   gen() 15634 MB/s
> [Mi Jan 30 19:14:18 2019] raid6: avx2x2   xor()  9519 MB/s
> [Mi Jan 30 19:14:18 2019] raid6: avx2x4   gen() 18228 MB/s
> [Mi Jan 30 19:14:18 2019] raid6: avx2x4   xor() 11505 MB/s
> [Mi Jan 30 19:14:18 2019] raid6: using algorithm avx2x4 gen() 18228 MB/s
> [Mi Jan 30 19:14:18 2019] raid6: .... xor() 11505 MB/s, rmw enabled
> [Mi Jan 30 19:14:18 2019] raid6: using avx2x2 recovery algorithm
> [Mi Jan 30 19:14:18 2019] xor: automatically using best checksumming
> function   avx
> [Mi Jan 30 19:14:18 2019] Btrfs loaded, crc32c=3Dcrc32c-intel
> [Mi Jan 30 19:16:40 2019] usbcore: deregistering interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:16:40 2019] dvb_usb_v2: 'TechnoTrend TVStick CT2-4400:1-3'
> successfully deinitialized and disconnected
> [Mi Jan 30 19:16:40 2019] PM: suspend entry (deep)
> [Mi Jan 30 19:16:40 2019] PM: Syncing filesystems ... done.
> [Mi Jan 30 19:16:41 2019] Freezing user space processes ... (elapsed
> 0.001 seconds) done.
> [Mi Jan 30 19:16:41 2019] OOM killer disabled.
> [Mi Jan 30 19:16:41 2019] Freezing remaining freezable tasks ...
> (elapsed 0.000 seconds) done.
> [Mi Jan 30 19:16:41 2019] Suspending console(s) (use no_console_suspend
> to debug)
> [Mi Jan 30 19:16:41 2019] nuvoton-cir 00:01: disabled
> [Mi Jan 30 19:16:41 2019] e1000e: EEE TX LPI TIMER: 00000011
> [Mi Jan 30 19:16:41 2019] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [Mi Jan 30 19:16:41 2019] sd 0:0:0:0: [sda] Stopping disk
> [Mi Jan 30 19:16:41 2019] ACPI: Preparing to enter system sleep state S3
> [Mi Jan 30 19:16:41 2019] PM: Saving platform NVS memory
> [Mi Jan 30 19:16:41 2019] Disabling non-boot CPUs ...
> [Mi Jan 30 19:16:41 2019] IRQ 43: no longer affine to CPU1
> [Mi Jan 30 19:16:41 2019] smpboot: CPU 1 is now offline
> [Mi Jan 30 19:16:41 2019] IRQ 44: no longer affine to CPU2
> [Mi Jan 30 19:16:41 2019] smpboot: CPU 2 is now offline
> [Mi Jan 30 19:16:42 2019] IRQ 42: no longer affine to CPU3
> [Mi Jan 30 19:16:42 2019] smpboot: CPU 3 is now offline
> [Mi Jan 30 19:16:42 2019] ACPI: Low-level resume complete
> [Mi Jan 30 19:16:42 2019] PM: Restoring platform NVS memory
> [Mi Jan 30 19:16:42 2019] Enabling non-boot CPUs ...
> [Mi Jan 30 19:16:42 2019] x86: Booting SMP configuration:
> [Mi Jan 30 19:16:42 2019] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [Mi Jan 30 19:16:42 2019]  cache: parent cpu1 should not be sleeping
> [Mi Jan 30 19:16:42 2019] CPU1 is up
> [Mi Jan 30 19:16:42 2019] smpboot: Booting Node 0 Processor 2 APIC 0x1
> [Mi Jan 30 19:16:42 2019]  cache: parent cpu2 should not be sleeping
> [Mi Jan 30 19:16:42 2019] CPU2 is up
> [Mi Jan 30 19:16:42 2019] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [Mi Jan 30 19:16:42 2019]  cache: parent cpu3 should not be sleeping
> [Mi Jan 30 19:16:42 2019] CPU3 is up
> [Mi Jan 30 19:16:42 2019] ACPI: Waking up from system sleep state S3
> [Mi Jan 30 19:16:42 2019] sd 0:0:0:0: [sda] Starting disk
> [Mi Jan 30 19:16:42 2019] nuvoton-cir 00:01: activated
> [Mi Jan 30 19:16:42 2019] ata1: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> [Mi Jan 30 19:16:42 2019] ata1.00: configured for UDMA/133
> [Mi Jan 30 19:16:43 2019] OOM killer enabled.
> [Mi Jan 30 19:16:43 2019] Restarting tasks ... done.
> [Mi Jan 30 19:16:43 2019] PM: suspend exit
> [Mi Jan 30 19:16:43 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend
> TVStick CT2-4400' in warm state
> [Mi Jan 30 19:16:43 2019] usb 1-3: dvb_usb_v2: will pass the complete
> MPEG2 transport stream to the software demuxer
> [Mi Jan 30 19:16:43 2019] dvbdev: DVB: registering new adapter
> (TechnoTrend TVStick CT2-4400)
> [Mi Jan 30 19:16:43 2019] usb 1-3: dvb_usb_v2: MAC address:
> bc:ea:2b:44:0f:89
> [Mi Jan 30 19:16:43 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan 30 19:16:43 2019] si2168 6-0064: Silicon Labs Si2168-B40
> successfully identified
> [Mi Jan 30 19:16:43 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan 30 19:16:43 2019] si2157 7-0060: Silicon Labs
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan 30 19:16:43 2019] usb 1-3: DVB: registering adapter 0 frontend 0
> (Silicon Labs Si2168)...
> [Mi Jan 30 19:16:43 2019] sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:14.0/usb1/1-3/dvb/dvb0.frontend0'
> [Mi Jan 30 19:16:43 2019] CPU: 2 PID: 13415 Comm: modprobe Not tainted
> 4.19.0-1-amd64 #1 Debian 4.19.12-1
> [Mi Jan 30 19:16:43 2019] Hardware name:  /NUC5i3RYB, BIOS
> RYBDWi35.86A.0371.2018.0709.1155 07/09/2018
> [Mi Jan 30 19:16:43 2019] Call Trace:
> [Mi Jan 30 19:16:43 2019]  dump_stack+0x5c/0x80
> [Mi Jan 30 19:16:43 2019]  sysfs_warn_dup.cold.4+0x17/0x2a
> [Mi Jan 30 19:16:43 2019]  sysfs_create_dir_ns+0xa7/0xd0
> [Mi Jan 30 19:16:43 2019]  kobject_add_internal+0xbc/0x270
> [Mi Jan 30 19:16:43 2019]  kobject_add+0x7d/0xb0
> [Mi Jan 30 19:16:43 2019]  ? refcount_inc_checked+0x5/0x30
> [Mi Jan 30 19:16:43 2019]  device_add+0x125/0x690
> [Mi Jan 30 19:16:43 2019]  device_create_groups_vargs+0xd1/0xf0
> [Mi Jan 30 19:16:43 2019]  device_create+0x49/0x60
> [Mi Jan 30 19:16:43 2019]  ? _cond_resched+0x15/0x30
> [Mi Jan 30 19:16:43 2019]  ? kmem_cache_alloc_trace+0x155/0x1d0
> [Mi Jan 30 19:16:43 2019]  dvb_register_device+0x229/0x2c0 [dvb_core]
> [Mi Jan 30 19:16:43 2019]  dvb_register_frontend+0x17b/0x210 [dvb_core]
> [Mi Jan 30 19:16:43 2019]  dvb_usbv2_probe+0x64b/0x10d0 [dvb_usb_v2]
> [Mi Jan 30 19:16:43 2019]  ? __pm_runtime_set_status+0x247/0x260
> [Mi Jan 30 19:16:43 2019]  usb_probe_interface+0xe4/0x2f0 [usbcore]
> [Mi Jan 30 19:16:43 2019]  really_probe+0x235/0x3a0
> [Mi Jan 30 19:16:43 2019]  driver_probe_device+0xb3/0xf0
> [Mi Jan 30 19:16:43 2019]  __driver_attach+0xdd/0x110
> [Mi Jan 30 19:16:43 2019]  ? driver_probe_device+0xf0/0xf0
> [Mi Jan 30 19:16:43 2019]  bus_for_each_dev+0x76/0xc0
> [Mi Jan 30 19:16:43 2019]  ? klist_add_tail+0x3b/0x70
> [Mi Jan 30 19:16:43 2019]  bus_add_driver+0x152/0x230
> [Mi Jan 30 19:16:43 2019]  driver_register+0x6b/0xb0
> [Mi Jan 30 19:16:43 2019]  usb_register_driver+0x7a/0x130 [usbcore]
> [Mi Jan 30 19:16:43 2019]  ? 0xffffffffc046e000
> [Mi Jan 30 19:16:43 2019]  do_one_initcall+0x46/0x1c3
> [Mi Jan 30 19:16:43 2019]  ? free_unref_page_commit+0x91/0x100
> [Mi Jan 30 19:16:43 2019]  ? _cond_resched+0x15/0x30
> [Mi Jan 30 19:16:43 2019]  ? kmem_cache_alloc_trace+0x155/0x1d0
> [Mi Jan 30 19:16:43 2019]  do_init_module+0x5a/0x210
> [Mi Jan 30 19:16:43 2019]  load_module+0x215c/0x2380
> [Mi Jan 30 19:16:43 2019]  ? __do_sys_finit_module+0xad/0x110
> [Mi Jan 30 19:16:43 2019]  __do_sys_finit_module+0xad/0x110
> [Mi Jan 30 19:16:43 2019]  do_syscall_64+0x53/0x100
> [Mi Jan 30 19:16:43 2019] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [Mi Jan 30 19:16:43 2019] RIP: 0033:0x7f9315f49269
> [Mi Jan 30 19:16:43 2019] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f
> 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
> 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f7 6b 0c 00 f7 d8
> 64 89 01 48
> [Mi Jan 30 19:16:43 2019] RSP: 002b:00007ffd432f8258 EFLAGS: 00000246
> ORIG_RAX: 0000000000000139
> [Mi Jan 30 19:16:43 2019] RAX: ffffffffffffffda RBX: 0000560666771de0
> RCX: 00007f9315f49269
> [Mi Jan 30 19:16:43 2019] RDX: 0000000000000000 RSI: 0000560666774bd0
> RDI: 0000000000000003
> [Mi Jan 30 19:16:43 2019] RBP: 0000560666774bd0 R08: 0000000000000000
> R09: 0000000000000000
> [Mi Jan 30 19:16:43 2019] R10: 0000000000000003 R11: 0000000000000246
> R12: 0000000000000000
> [Mi Jan 30 19:16:43 2019] R13: 0000560666771e60 R14: 0000000000040000
> R15: 0000560666771de0
> [Mi Jan 30 19:16:43 2019] kobject_add_internal failed for dvb0.frontend0
> with -EEXIST, don't try to register things with the same name in the
> same directory.
> [Mi Jan 30 19:16:43 2019] dvbdev: dvb_register_device: failed to create
> device dvb0.frontend0 (-17)
> [Mi Jan 30 19:16:43 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick
> CT2-4400' successfully initialized and connected
> [Mi Jan 30 19:16:43 2019] usbcore: registered new interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:16:46 2019] e1000e: enp0s25 NIC Link is Up 10 Mbps Full
> Duplex, Flow Control: Rx/Tx
> [Mi Jan 30 19:16:46 2019] e1000e 0000:00:19.0 enp0s25: 10/100 speed:
> disabling TSO
> [Mi Jan 30 19:16:55 2019] input: Sundtek Remote Control as
> /devices/virtual/input/input23
> [Mi Jan 30 19:17:00 2019] usb 1-4: usbfs: process 13562 (mediasrv) did
> not claim interface 2 before use
>
> dmesg output with 4.9:
>
> [Mi Jan 30 19:18:01 2019] Linux version 4.9.0-8-amd64
> (debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian
> 6.3.0-18+deb9u1) ) #1 SMP Debian 4.9.130-2 (2018-10-27)
> [Mi Jan 30 19:18:01 2019] Command line:
> BOOT_IMAGE=3D/vmlinuz-4.9.0-8-amd64 root=3D/dev/mapper/cryptvol-rootfs ro
> quiet splash kopt=3Droot=3D/dev/mapper/cryptvol-rootfs
> [Mi Jan 30 19:18:01 2019] x86/fpu: Supporting XSAVE feature 0x001: 'x87
> floating point registers'
> [Mi Jan 30 19:18:01 2019] x86/fpu: Supporting XSAVE feature 0x002: 'SSE
> registers'
> [Mi Jan 30 19:18:01 2019] x86/fpu: Supporting XSAVE feature 0x004: 'AVX
> registers'
> [Mi Jan 30 19:18:01 2019] x86/fpu: xstate_offset[2]:  576,
> xstate_sizes[2]:  256
> [Mi Jan 30 19:18:01 2019] x86/fpu: Enabled xstate features 0x7, context
> size is 832 bytes, using 'standard' format.
> [Mi Jan 30 19:18:01 2019] e820: BIOS-provided physical RAM map:
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000000000000-0x000000000009c7ff] usable
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x000000000009c800-0x000000000009ffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000000e0000-0x00000000000fffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000000100000-0x000000008cf86fff] usable
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x000000008cf87000-0x000000008d45dfff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x000000008d45e000-0x0000000092289fff] usable
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x000000009228a000-0x0000000092347fff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000092348000-0x000000009236dfff] ACPI data
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x000000009236e000-0x0000000092c9dfff] ACPI NVS
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000092c9e000-0x0000000092ffefff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000092fff000-0x0000000092ffffff] usable
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000093800000-0x0000000097ffffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000f8000000-0x00000000fbffffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000fec00000-0x00000000fec00fff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000fed00000-0x00000000fed03fff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000fee00000-0x00000000fee00fff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x00000000ff000000-0x00000000ffffffff] reserved
> [Mi Jan 30 19:18:01 2019] BIOS-e820: [mem
> 0x0000000100000000-0x0000000166ffffff] usable
> [Mi Jan 30 19:18:01 2019] NX (Execute Disable) protection: active
> [Mi Jan 30 19:18:01 2019] SMBIOS 2.8 present.
> [Mi Jan 30 19:18:01 2019] DMI:  /NUC5i3RYB, BIOS
> RYBDWi35.86A.0371.2018.0709.1155 07/09/2018
> [Mi Jan 30 19:18:01 2019] e820: update [mem 0x00000000-0x00000fff]
> usable =3D=3D> reserved
> [Mi Jan 30 19:18:01 2019] e820: remove [mem 0x000a0000-0x000fffff] usable
> [Mi Jan 30 19:18:01 2019] e820: last_pfn =3D 0x167000 max_arch_pfn =3D
> 0x400000000
> [Mi Jan 30 19:18:01 2019] MTRR default type: uncachable
> [Mi Jan 30 19:18:01 2019] MTRR fixed ranges enabled:
> [Mi Jan 30 19:18:01 2019]   00000-9FFFF write-back
> [Mi Jan 30 19:18:01 2019]   A0000-BFFFF uncachable
> [Mi Jan 30 19:18:01 2019]   C0000-FFFFF write-protect
> [Mi Jan 30 19:18:01 2019] MTRR variable ranges enabled:
> [Mi Jan 30 19:18:01 2019]   0 base 0000000000 mask 7F80000000 write-back
> [Mi Jan 30 19:18:01 2019]   1 base 0080000000 mask 7FF0000000 write-back
> [Mi Jan 30 19:18:01 2019]   2 base 0090000000 mask 7FFE000000 write-back
> [Mi Jan 30 19:18:01 2019]   3 base 0092000000 mask 7FFF000000 write-back
> [Mi Jan 30 19:18:01 2019]   4 base 0100000000 mask 7FC0000000 write-back
> [Mi Jan 30 19:18:01 2019]   5 base 0140000000 mask 7FE0000000 write-back
> [Mi Jan 30 19:18:01 2019]   6 base 0160000000 mask 7FFC000000 write-back
> [Mi Jan 30 19:18:01 2019]   7 base 0164000000 mask 7FFE000000 write-back
> [Mi Jan 30 19:18:01 2019]   8 base 0166000000 mask 7FFF000000 write-back
> [Mi Jan 30 19:18:01 2019]   9 disabled
> [Mi Jan 30 19:18:01 2019] x86/PAT: Configuration [0-7]: WB  WC UC- UC
> WB  WC  UC- WT
> [Mi Jan 30 19:18:01 2019] e820: update [mem 0x93000000-0xffffffff]
> usable =3D=3D> reserved
> [Mi Jan 30 19:18:01 2019] e820: last_pfn =3D 0x93000 max_arch_pfn =3D
> 0x400000000
> [Mi Jan 30 19:18:01 2019] found SMP MP-table at [mem
> 0x000fcaf0-0x000fcaff] mapped at [ffff9831c00fcaf0]
> [Mi Jan 30 19:18:01 2019] Base memory trampoline at [ffff9831c0096000]
> 96000 size 24576
> [Mi Jan 30 19:18:01 2019] Using GB pages for direct mapping
> [Mi Jan 30 19:18:01 2019] BRK [0x5813a000, 0x5813afff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x5813b000, 0x5813bfff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x5813c000, 0x5813cfff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x5813d000, 0x5813dfff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x5813e000, 0x5813efff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x5813f000, 0x5813ffff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x58140000, 0x58140fff] PGTABLE
> [Mi Jan 30 19:18:01 2019] BRK [0x58141000, 0x58141fff] PGTABLE
> [Mi Jan 30 19:18:01 2019] RAMDISK: [mem 0x3667b000-0x37334fff]
> [Mi Jan 30 19:18:01 2019] ACPI: Early table checksum verification disable=
d
> [Mi Jan 30 19:18:01 2019] ACPI: RSDP 0x00000000000F05B0 000024 (v02 INTEL=
 )
> [Mi Jan 30 19:18:01 2019] ACPI: XSDT 0x000000009234F090 00009C (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:18:01 2019] ACPI: FACP 0x0000000092365048 00010C (v05
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:18:01 2019] ACPI: DSDT 0x000000009234F1B8 015E8C (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: FACS 0x0000000092C9CF80 000040
> [Mi Jan 30 19:18:01 2019] ACPI: APIC 0x0000000092365158 000084 (v03
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:18:01 2019] ACPI: FPDT 0x00000000923651E0 000044 (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:18:01 2019] ACPI: FIDT 0x0000000092365228 00009C (v01
> INTEL  NUC5i3RY 00000173 AMI  00010013)
> [Mi Jan 30 19:18:01 2019] ACPI: MCFG 0x00000000923652C8 00003C (v01
> INTEL  NUC5i3RY 00000173 MSFT 00000097)
> [Mi Jan 30 19:18:01 2019] ACPI: HPET 0x0000000092365308 000038 (v01
> INTEL  NUC5i3RY 00000173 AMI. 0005000B)
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0x0000000092365340 000315 (v01
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: UEFI 0x0000000092365658 000042 (v01
> INTEL  NUC5i3RY 00000173      00000000)
> [Mi Jan 30 19:18:01 2019] ACPI: LPIT 0x00000000923656A0 000094 (v01
> INTEL  NUC5i3RY 00000173      00000000)
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0x0000000092365738 000C7D (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: ASF! 0x00000000923663B8 0000A0 (v32
> INTEL  NUC5i3RY 00000173 TFSM 000F4240)
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0x0000000092366458 000539 (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0x0000000092366998 000B74 (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0x0000000092367510 005AFE (v02
> INTEL  NUC5i3RY 00000173 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: DMAR 0x000000009236D010 0000D4 (v01
> INTEL  NUC5i3RY 00000173 INTL 00000001)
> [Mi Jan 30 19:18:01 2019] ACPI: Local APIC address 0xfee00000
> [Mi Jan 30 19:18:01 2019] No NUMA configuration found
> [Mi Jan 30 19:18:01 2019] Faking a node at [mem
> 0x0000000000000000-0x0000000166ffffff]
> [Mi Jan 30 19:18:01 2019] NODE_DATA(0) allocated [mem
> 0x166ff9000-0x166ffdfff]
> [Mi Jan 30 19:18:01 2019] Zone ranges:
> [Mi Jan 30 19:18:01 2019]   DMA      [mem
> 0x0000000000001000-0x0000000000ffffff]
> [Mi Jan 30 19:18:01 2019]   DMA32    [mem
> 0x0000000001000000-0x00000000ffffffff]
> [Mi Jan 30 19:18:01 2019]   Normal   [mem
> 0x0000000100000000-0x0000000166ffffff]
> [Mi Jan 30 19:18:01 2019]   Device   empty
> [Mi Jan 30 19:18:01 2019] Movable zone start for each node
> [Mi Jan 30 19:18:01 2019] Early memory node ranges
> [Mi Jan 30 19:18:01 2019]   node   0: [mem
> 0x0000000000001000-0x000000000009bfff]
> [Mi Jan 30 19:18:01 2019]   node   0: [mem
> 0x0000000000100000-0x000000008cf86fff]
> [Mi Jan 30 19:18:01 2019]   node   0: [mem
> 0x000000008d45e000-0x0000000092289fff]
> [Mi Jan 30 19:18:01 2019]   node   0: [mem
> 0x0000000092fff000-0x0000000092ffffff]
> [Mi Jan 30 19:18:01 2019]   node   0: [mem
> 0x0000000100000000-0x0000000166ffffff]
> [Mi Jan 30 19:18:01 2019] Initmem setup node 0 [mem
> 0x0000000000001000-0x0000000166ffffff]
> [Mi Jan 30 19:18:01 2019] On node 0 totalpages: 1019215
> [Mi Jan 30 19:18:01 2019]   DMA zone: 64 pages used for memmap
> [Mi Jan 30 19:18:01 2019]   DMA zone: 21 pages reserved
> [Mi Jan 30 19:18:01 2019]   DMA zone: 3995 pages, LIFO batch:0
> [Mi Jan 30 19:18:01 2019]   DMA32 zone: 9271 pages used for memmap
> [Mi Jan 30 19:18:01 2019]   DMA32 zone: 593332 pages, LIFO batch:31
> [Mi Jan 30 19:18:01 2019]   Normal zone: 6592 pages used for memmap
> [Mi Jan 30 19:18:01 2019]   Normal zone: 421888 pages, LIFO batch:31
> [Mi Jan 30 19:18:01 2019] Reserving Intel graphics memory at
> 0x0000000094000000-0x0000000097ffffff
> [Mi Jan 30 19:18:01 2019] ACPI: PM-Timer IO Port: 0x1808
> [Mi Jan 30 19:18:01 2019] ACPI: Local APIC address 0xfee00000
> [Mi Jan 30 19:18:01 2019] ACPI: LAPIC_NMI (acpi_id[0x01] high res
> lint[0x41])
> [Mi Jan 30 19:18:01 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:18:01 2019] ACPI: LAPIC_NMI (acpi_id[0x02] dfl res lint[0x4=
1])
> [Mi Jan 30 19:18:01 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:18:01 2019] ACPI: LAPIC_NMI (acpi_id[0x03] res res lint[0xc=
f])
> [Mi Jan 30 19:18:01 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:18:01 2019] ACPI: LAPIC_NMI (acpi_id[0x04] dfl edge
> lint[0x6b])
> [Mi Jan 30 19:18:01 2019] ACPI: NMI not connected to LINT 1!
> [Mi Jan 30 19:18:01 2019] IOAPIC[0]: apic_id 2, version 32, address
> 0xfec00000, GSI 0-39
> [Mi Jan 30 19:18:01 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq
> 2 dfl dfl)
> [Mi Jan 30 19:18:01 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq
> 9 high level)
> [Mi Jan 30 19:18:01 2019] ACPI: IRQ0 used by override.
> [Mi Jan 30 19:18:01 2019] ACPI: IRQ9 used by override.
> [Mi Jan 30 19:18:01 2019] Using ACPI (MADT) for SMP configuration
> information
> [Mi Jan 30 19:18:01 2019] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [Mi Jan 30 19:18:01 2019] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x00000000-0x00000fff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x0009c000-0x0009cfff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x0009d000-0x0009ffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x000a0000-0x000dffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x000e0000-0x000fffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x8cf87000-0x8d45dfff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x9228a000-0x92347fff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x92348000-0x9236dfff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x9236e000-0x92c9dfff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x92c9e000-0x92ffefff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x93000000-0x937fffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x93800000-0x97ffffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0x98000000-0xf7ffffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xf8000000-0xfbffffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfc000000-0xfebfffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfec00000-0xfec00fff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfec01000-0xfecfffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfed00000-0xfed03fff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfed04000-0xfed1bfff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfed1c000-0xfed1ffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfed20000-0xfedfffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfee00000-0xfee00fff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xfee01000-0xfeffffff]
> [Mi Jan 30 19:18:01 2019] PM: Registered nosave memory: [mem
> 0xff000000-0xffffffff]
> [Mi Jan 30 19:18:01 2019] e820: [mem 0x98000000-0xf7ffffff] available
> for PCI devices
> [Mi Jan 30 19:18:01 2019] Booting paravirtualized kernel on bare hardware
> [Mi Jan 30 19:18:01 2019] clocksource: refined-jiffies: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
> [Mi Jan 30 19:18:01 2019] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
> nr_cpu_ids:4 nr_node_ids:1
> [Mi Jan 30 19:18:01 2019] percpu: Embedded 35 pages/cpu
> @ffff983326c00000 s105304 r8192 d29864 u524288
> [Mi Jan 30 19:18:01 2019] pcpu-alloc: s105304 r8192 d29864 u524288
> alloc=3D1*2097152
> [Mi Jan 30 19:18:01 2019] pcpu-alloc: [0] 0 1 2 3
> [Mi Jan 30 19:18:01 2019] Built 1 zonelists in Node order, mobility
> grouping on.  Total pages: 1003267
> [Mi Jan 30 19:18:01 2019] Policy zone: Normal
> [Mi Jan 30 19:18:01 2019] Kernel command line:
> BOOT_IMAGE=3D/vmlinuz-4.9.0-8-amd64 root=3D/dev/mapper/cryptvol-rootfs ro
> quiet splash kopt=3Droot=3D/dev/mapper/cryptvol-rootfs
> [Mi Jan 30 19:18:01 2019] PID hash table entries: 4096 (order: 3, 32768
> bytes)
> [Mi Jan 30 19:18:01 2019] Calgary: detecting Calgary via BIOS EBDA area
> [Mi Jan 30 19:18:01 2019] Calgary: Unable to locate Rio Grande table in
> EBDA - bailing!
> [Mi Jan 30 19:18:01 2019] Memory: 3915964K/4076860K available (6267K
> kernel code, 1159K rwdata, 2872K rodata, 1420K init, 688K bss, 160896K
> reserved, 0K cma-reserved)
> [Mi Jan 30 19:18:01 2019] Kernel/User page tables isolation: enabled
> [Mi Jan 30 19:18:01 2019] Hierarchical RCU implementation.
> [Mi Jan 30 19:18:01 2019]     Build-time adjustment of leaf fanout to 64.
> [Mi Jan 30 19:18:01 2019]     RCU restricting CPUs from NR_CPUS=3D512 to
> nr_cpu_ids=3D4.
> [Mi Jan 30 19:18:01 2019] RCU: Adjusting geometry for
> rcu_fanout_leaf=3D64, nr_cpu_ids=3D4
> [Mi Jan 30 19:18:01 2019] NR_IRQS:33024 nr_irqs:728 16
> [Mi Jan 30 19:18:01 2019] spurious 8259A interrupt: IRQ7.
> [Mi Jan 30 19:18:01 2019] Console: colour VGA+ 80x25
> [Mi Jan 30 19:18:01 2019] console [tty0] enabled
> [Mi Jan 30 19:18:01 2019] clocksource: hpet: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
> [Mi Jan 30 19:18:01 2019] hpet clockevent registered
> [Mi Jan 30 19:18:01 2019] tsc: Fast TSC calibration using PIT
> [Mi Jan 30 19:18:01 2019] tsc: Detected 2095.017 MHz processor
> [Mi Jan 30 19:18:01 2019] Calibrating delay loop (skipped), value
> calculated using timer frequency.. 4190.03 BogoMIPS (lpj=3D8380068)
> [Mi Jan 30 19:18:01 2019] pid_max: default: 32768 minimum: 301
> [Mi Jan 30 19:18:01 2019] ACPI: Core revision 20160831
> [Mi Jan 30 19:18:01 2019] ACPI: 6 ACPI AML tables successfully acquired
> and loaded
> [Mi Jan 30 19:18:01 2019] Security Framework initialized
> [Mi Jan 30 19:18:01 2019] Yama: disabled by default; enable with sysctl
> kernel.yama.*
> [Mi Jan 30 19:18:01 2019] AppArmor: AppArmor disabled by boot time parame=
ter
> [Mi Jan 30 19:18:01 2019] Dentry cache hash table entries: 524288
> (order: 10, 4194304 bytes)
> [Mi Jan 30 19:18:01 2019] Inode-cache hash table entries: 262144 (order:
> 9, 2097152 bytes)
> [Mi Jan 30 19:18:01 2019] Mount-cache hash table entries: 8192 (order:
> 4, 65536 bytes)
> [Mi Jan 30 19:18:01 2019] Mountpoint-cache hash table entries: 8192
> (order: 4, 65536 bytes)
> [Mi Jan 30 19:18:01 2019] ENERGY_PERF_BIAS: Set to 'normal', was
> 'performance'
> [Mi Jan 30 19:18:01 2019] ENERGY_PERF_BIAS: View and update with
> x86_energy_perf_policy(8)
> [Mi Jan 30 19:18:01 2019] mce: CPU supports 7 MCE banks
> [Mi Jan 30 19:18:01 2019] CPU0: Thermal monitoring enabled (TM1)
> [Mi Jan 30 19:18:01 2019] process: using mwait in idle threads
> [Mi Jan 30 19:18:01 2019] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
> [Mi Jan 30 19:18:01 2019] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0,
> 1GB 4
> [Mi Jan 30 19:18:01 2019] Spectre V2 : Mitigation: Full generic retpoline
> [Mi Jan 30 19:18:01 2019] Spectre V2 : Spectre v2 / SpectreRSB
> mitigation: Filling RSB on context switch
> [Mi Jan 30 19:18:01 2019] Spectre V2 : Spectre v2 mitigation: Enabling
> Indirect Branch Prediction Barrier
> [Mi Jan 30 19:18:01 2019] Spectre V2 : Enabling Restricted Speculation
> for firmware calls
> [Mi Jan 30 19:18:01 2019] Speculative Store Bypass: Mitigation:
> Speculative Store Bypass disabled via prctl and seccomp
> [Mi Jan 30 19:18:01 2019] Freeing SMP alternatives memory: 24K
> [Mi Jan 30 19:18:01 2019] ftrace: allocating 25291 entries in 99 pages
> [Mi Jan 30 19:18:01 2019] smpboot: Max logical packages: 2
> [Mi Jan 30 19:18:01 2019] DMAR: Host address width 39
> [Mi Jan 30 19:18:01 2019] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [Mi Jan 30 19:18:01 2019] DMAR: dmar0: reg_base_addr fed90000 ver 1:0
> cap 1c0000c40660462 ecap 7e1ff0505e
> [Mi Jan 30 19:18:01 2019] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [Mi Jan 30 19:18:01 2019] DMAR: dmar1: reg_base_addr fed91000 ver 1:0
> cap d2008c20660462 ecap f010da
> [Mi Jan 30 19:18:01 2019] DMAR: RMRR base: 0x00000092ef3000 end:
> 0x00000092f03fff
> [Mi Jan 30 19:18:01 2019] DMAR: RMRR base: 0x00000093800000 end:
> 0x00000097ffffff
> [Mi Jan 30 19:18:01 2019] DMAR: ANDD device: 2 name: \_SB.PCI0.SDHC
> [Mi Jan 30 19:18:01 2019] DMAR-IR: IOAPIC id 2 under DRHD base
> 0xfed91000 IOMMU 1
> [Mi Jan 30 19:18:01 2019] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [Mi Jan 30 19:18:01 2019] DMAR-IR: x2apic is disabled because BIOS sets
> x2apic opt out bit.
> [Mi Jan 30 19:18:01 2019] DMAR-IR: Use 'intremap=3Dno_x2apic_optout' to
> override the BIOS setting.
> [Mi Jan 30 19:18:01 2019] DMAR-IR: Enabled IRQ remapping in xapic mode
> [Mi Jan 30 19:18:01 2019] x2apic: IRQ remapping doesn't support X2APIC mo=
de
> [Mi Jan 30 19:18:01 2019] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=
=3D-1
> pin2=3D-1
> [Mi Jan 30 19:18:01 2019] TSC deadline timer enabled
> [Mi Jan 30 19:18:01 2019] smpboot: CPU0: Intel(R) Core(TM) i3-5010U CPU
> @ 2.10GHz (family: 0x6, model: 0x3d, stepping: 0x4)
> [Mi Jan 30 19:18:01 2019] Performance Events: PEBS fmt2+, Broadwell
> events, 16-deep LBR, full-width counters, Intel PMU driver.
> [Mi Jan 30 19:18:01 2019] ... version:                3
> [Mi Jan 30 19:18:01 2019] ... bit width:              48
> [Mi Jan 30 19:18:01 2019] ... generic registers:      4
> [Mi Jan 30 19:18:01 2019] ... value mask: 0000ffffffffffff
> [Mi Jan 30 19:18:01 2019] ... max period: 00007fffffffffff
> [Mi Jan 30 19:18:01 2019] ... fixed-purpose events:   3
> [Mi Jan 30 19:18:01 2019] ... event mask: 000000070000000f
> [Mi Jan 30 19:18:01 2019] NMI watchdog: enabled on all CPUs, permanently
> consumes one hw-PMU counter.
> [Mi Jan 30 19:18:01 2019] x86: Booting SMP configuration:
> [Mi Jan 30 19:18:01 2019] .... node  #0, CPUs:      #1 #2 #3
> [Mi Jan 30 19:18:01 2019] x86: Booted up 1 node, 4 CPUs
> [Mi Jan 30 19:18:01 2019] smpboot: Total of 4 processors activated
> (16760.13 BogoMIPS)
> [Mi Jan 30 19:18:01 2019] devtmpfs: initialized
> [Mi Jan 30 19:18:01 2019] x86/mm: Memory block size: 128MB
> [Mi Jan 30 19:18:01 2019] PM: Registering ACPI NVS region [mem
> 0x9236e000-0x92c9dfff] (9633792 bytes)
> [Mi Jan 30 19:18:01 2019] clocksource: jiffies: mask: 0xffffffff
> max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [Mi Jan 30 19:18:01 2019] futex hash table entries: 1024 (order: 4,
> 65536 bytes)
> [Mi Jan 30 19:18:01 2019] pinctrl core: initialized pinctrl subsystem
> [Mi Jan 30 19:18:01 2019] NET: Registered protocol family 16
> [Mi Jan 30 19:18:01 2019] cpuidle: using governor ladder
> [Mi Jan 30 19:18:01 2019] cpuidle: using governor menu
> [Mi Jan 30 19:18:01 2019] ACPI FADT declares the system doesn't support
> PCIe ASPM, so disable it
> [Mi Jan 30 19:18:01 2019] ACPI: bus type PCI registered
> [Mi Jan 30 19:18:01 2019] acpiphp: ACPI Hot Plug PCI Controller Driver
> version: 0.5
> [Mi Jan 30 19:18:01 2019] PCI: MMCONFIG for domain 0000 [bus 00-3f] at
> [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [Mi Jan 30 19:18:01 2019] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff]
> reserved in E820
> [Mi Jan 30 19:18:01 2019] PCI: Using configuration type 1 for base access
> [Mi Jan 30 19:18:01 2019] mtrr: your CPUs had inconsistent variable MTRR
> settings
> [Mi Jan 30 19:18:01 2019] mtrr: probably your BIOS does not setup all CPU=
s.
> [Mi Jan 30 19:18:01 2019] mtrr: corrected configuration.
> [Mi Jan 30 19:18:01 2019] HugeTLB registered 1 GB page size,
> pre-allocated 0 pages
> [Mi Jan 30 19:18:01 2019] HugeTLB registered 2 MB page size,
> pre-allocated 0 pages
> [Mi Jan 30 19:18:01 2019] ACPI: Added _OSI(Module Device)
> [Mi Jan 30 19:18:01 2019] ACPI: Added _OSI(Processor Device)
> [Mi Jan 30 19:18:01 2019] ACPI: Added _OSI(3.0 _SCP Extensions)
> [Mi Jan 30 19:18:01 2019] ACPI: Added _OSI(Processor Aggregator Device)
> [Mi Jan 30 19:18:01 2019] ACPI: Executed 18 blocks of module-level
> executable AML code
> [Mi Jan 30 19:18:01 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0xFFFF983321323C00 0003D3 (v02
> PmRef  Cpu0Cst  00003001 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0xFFFF9833212CD800 0005AA (v02
> PmRef  ApIst    00003000 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: Dynamic OEM Table Load:
> [Mi Jan 30 19:18:01 2019] ACPI: SSDT 0xFFFF9833212CAC00 000119 (v02
> PmRef  ApCst    00003000 INTL 20120913)
> [Mi Jan 30 19:18:01 2019] ACPI: Interpreter enabled
> [Mi Jan 30 19:18:01 2019] ACPI: (supports S0 S3 S4 S5)
> [Mi Jan 30 19:18:01 2019] ACPI: Using IOAPIC for interrupt routing
> [Mi Jan 30 19:18:01 2019] PCI: Using host bridge windows from ACPI; if
> necessary, use "pci=3Dnocrs" and report a bug
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [PG00] (on)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [PG01] (on)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [PG02] (on)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [WRST] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [FN00] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [FN01] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [FN02] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [FN03] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: Power Resource [FN04] (off)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus
> 00-3e])
> [Mi Jan 30 19:18:01 2019] acpi PNP0A08:00: _OSC: OS supports
> [ExtendedConfig ASPM ClockPM Segments MSI]
> [Mi Jan 30 19:18:01 2019] acpi PNP0A08:00: _OSC failed (AE_ERROR);
> disabling ASPM
> [Mi Jan 30 19:18:01 2019] PCI host bridge to bus 0000:00
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [io
> 0x0000-0x0cf7 window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [io
> 0x0d00-0xffff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [mem
> 0x000a0000-0x000bffff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [mem
> 0x98000000-0xdfffffff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [mem
> 0xfe000000-0xfe113fff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: root bus resource [bus 00-3e]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:00.0: [8086:1604] type 00 class
> 0x060000
> [Mi Jan 30 19:18:01 2019] pci 0000:00:02.0: [8086:1616] type 00 class
> 0x030000
> [Mi Jan 30 19:18:01 2019] pci 0000:00:02.0: reg 0x10: [mem
> 0x99000000-0x99ffffff 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:02.0: reg 0x18: [mem
> 0xa0000000-0xbfffffff 64bit pref]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:02.0: reg 0x20: [io 0x3000-0x303f]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:03.0: [8086:160c] type 00 class
> 0x040300
> [Mi Jan 30 19:18:01 2019] pci 0000:00:03.0: reg 0x10: [mem
> 0x9a034000-0x9a037fff 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:14.0: [8086:9cb1] type 00 class
> 0x0c0330
> [Mi Jan 30 19:18:01 2019] pci 0000:00:14.0: reg 0x10: [mem
> 0x9a020000-0x9a02ffff 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:14.0: PME# supported from D3hot D3c=
old
> [Mi Jan 30 19:18:01 2019] pci 0000:00:14.0: System wakeup disabled by ACP=
I
> [Mi Jan 30 19:18:01 2019] pci 0000:00:16.0: [8086:9cba] type 00 class
> 0x078000
> [Mi Jan 30 19:18:01 2019] pci 0000:00:16.0: reg 0x10: [mem
> 0x9a03d000-0x9a03d01f 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:16.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: [8086:15a3] type 00 class
> 0x020000
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: reg 0x10: [mem
> 0x9a000000-0x9a01ffff]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: reg 0x14: [mem
> 0x9a03b000-0x9a03bfff]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: reg 0x18: [io 0x3080-0x309f]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:18:01 2019] pci 0000:00:19.0: System wakeup disabled by ACP=
I
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1b.0: [8086:9ca0] type 00 class
> 0x040300
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1b.0: reg 0x10: [mem
> 0x9a030000-0x9a033fff 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1b.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1b.0: System wakeup disabled by ACP=
I
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1d.0: [8086:9ca6] type 00 class
> 0x0c0320
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1d.0: reg 0x10: [mem
> 0x9a03a000-0x9a03a3ff]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1d.0: PME# supported from D0 D3hot
> D3cold
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1d.0: System wakeup disabled by ACP=
I
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.0: [8086:9cc3] type 00 class
> 0x060100
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: [8086:9c83] type 00 class
> 0x010601
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x10: [io 0x30d0-0x30d7]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x14: [io 0x30c0-0x30c3]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x18: [io 0x30b0-0x30b7]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x1c: [io 0x30a0-0x30a3]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x20: [io 0x3060-0x307f]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: reg 0x24: [mem
> 0x9a039000-0x9a0397ff]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.2: PME# supported from D3hot
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.3: [8086:9ca2] type 00 class
> 0x0c0500
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.3: reg 0x10: [mem
> 0x9a038000-0x9a0380ff 64bit]
> [Mi Jan 30 19:18:01 2019] pci 0000:00:1f.3: reg 0x20: [io 0x3040-0x305f]
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6
> 10 *11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6
> 10 11 12 14 15) *0, disabled.
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6
> *10 11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6
> *10 11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6
> 10 11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6
> 10 11 12 14 15) *0, disabled.
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6
> 10 11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6
> 10 *11 12 14 15)
> [Mi Jan 30 19:18:01 2019] ACPI: Enabled 4 GPEs in block 00 to 7F
> [Mi Jan 30 19:18:01 2019] vgaarb: setting as boot device: PCI:0000:00:02.=
0
> [Mi Jan 30 19:18:01 2019] vgaarb: device added:
> PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
> [Mi Jan 30 19:18:01 2019] vgaarb: loaded
> [Mi Jan 30 19:18:01 2019] vgaarb: bridge control possible 0000:00:02.0
> [Mi Jan 30 19:18:01 2019] PCI: Using ACPI for IRQ routing
> [Mi Jan 30 19:18:01 2019] PCI: pci_cache_line_size set to 64 bytes
> [Mi Jan 30 19:18:01 2019] e820: reserve RAM buffer [mem
> 0x0009c800-0x0009ffff]
> [Mi Jan 30 19:18:01 2019] e820: reserve RAM buffer [mem
> 0x8cf87000-0x8fffffff]
> [Mi Jan 30 19:18:01 2019] e820: reserve RAM buffer [mem
> 0x9228a000-0x93ffffff]
> [Mi Jan 30 19:18:01 2019] e820: reserve RAM buffer [mem
> 0x93000000-0x93ffffff]
> [Mi Jan 30 19:18:01 2019] e820: reserve RAM buffer [mem
> 0x167000000-0x167ffffff]
> [Mi Jan 30 19:18:01 2019] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0,
> 0, 0, 0
> [Mi Jan 30 19:18:01 2019] hpet0: 8 comparators, 64-bit 14.318180 MHz coun=
ter
> [Mi Jan 30 19:18:01 2019] clocksource: Switched to clocksource hpet
> [Mi Jan 30 19:18:01 2019] VFS: Disk quotas dquot_6.6.0
> [Mi Jan 30 19:18:01 2019] VFS: Dquot-cache hash table entries: 512
> (order 0, 4096 bytes)
> [Mi Jan 30 19:18:01 2019] pnp: PnP ACPI init
> [Mi Jan 30 19:18:01 2019] system 00:00: [io  0x0a00-0x0a0f] has been
> reserved
> [Mi Jan 30 19:18:01 2019] system 00:00: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:18:01 2019] pnp 00:01: Plug and Play ACPI device, IDs
> NTN0530 (active)
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0x0680-0x069f] has been
> reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0xffff] has been reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0x1800-0x18fe] has been
> reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: [io  0x164e-0x164f] has been
> reserved
> [Mi Jan 30 19:18:01 2019] system 00:02: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:18:01 2019] pnp 00:03: Plug and Play ACPI device, IDs
> PNP0b00 (active)
> [Mi Jan 30 19:18:01 2019] system 00:04: [io  0x1854-0x1857] has been
> reserved
> [Mi Jan 30 19:18:01 2019] system 00:04: Plug and Play ACPI device, IDs
> INT3f0d PNP0c02 (active)
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed1c000-0xfed1ffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed10000-0xfed17fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed18000-0xfed18fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed19000-0xfed19fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xf8000000-0xfbffffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed20000-0xfed3ffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed90000-0xfed93fff]
> could not be reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfed45000-0xfed8ffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xff000000-0xffffffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0xfee00000-0xfeefffff]
> could not be reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0x98010000-0x9801ffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: [mem 0x98000000-0x9800ffff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:05: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:18:01 2019] system 00:06: [mem 0xfe104000-0xfe104fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:06: [mem 0xfe106000-0xfe106fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:06: [mem 0xfe112000-0xfe112fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:06: [mem 0xfe111000-0xfe111007] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:06: [mem 0xfe111014-0xfe111fff] has
> been reserved
> [Mi Jan 30 19:18:01 2019] system 00:06: Plug and Play ACPI device, IDs
> PNP0c02 (active)
> [Mi Jan 30 19:18:01 2019] pnp: PnP ACPI: found 7 devices
> [Mi Jan 30 19:18:01 2019] clocksource: acpi_pm: mask: 0xffffff
> max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: resource 4 [io 0x0000-0x0cf7
> window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: resource 5 [io 0x0d00-0xffff
> window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: resource 6 [mem
> 0x000a0000-0x000bffff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: resource 7 [mem
> 0x98000000-0xdfffffff window]
> [Mi Jan 30 19:18:01 2019] pci_bus 0000:00: resource 8 [mem
> 0xfe000000-0xfe113fff window]
> [Mi Jan 30 19:18:01 2019] NET: Registered protocol family 2
> [Mi Jan 30 19:18:01 2019] TCP established hash table entries: 32768
> (order: 6, 262144 bytes)
> [Mi Jan 30 19:18:01 2019] TCP bind hash table entries: 32768 (order: 7,
> 524288 bytes)
> [Mi Jan 30 19:18:01 2019] TCP: Hash tables configured (established 32768
> bind 32768)
> [Mi Jan 30 19:18:01 2019] UDP hash table entries: 2048 (order: 4, 65536
> bytes)
> [Mi Jan 30 19:18:01 2019] UDP-Lite hash table entries: 2048 (order: 4,
> 65536 bytes)
> [Mi Jan 30 19:18:01 2019] NET: Registered protocol family 1
> [Mi Jan 30 19:18:01 2019] pci 0000:00:02.0: Video device with shadowed
> ROM at [mem 0x000c0000-0x000dffff]
> [Mi Jan 30 19:18:01 2019] PCI: CLS 0 bytes, default 64
> [Mi Jan 30 19:18:01 2019] Unpacking initramfs...
> [Mi Jan 30 19:18:01 2019] Freeing initrd memory: 13032K
> [Mi Jan 30 19:18:01 2019] DMAR: ACPI device "INT3436:00" under DMAR at
> fed91000 as 00:17.0
> [Mi Jan 30 19:18:01 2019] PCI-DMA: Using software bounce buffering for
> IO (SWIOTLB)
> [Mi Jan 30 19:18:01 2019] software IO TLB [mem 0x8e28a000-0x9228a000]
> (64MB) mapped at [ffff98324e28a000-ffff983252289fff]
> [Mi Jan 30 19:18:01 2019] audit: initializing netlink subsys (disabled)
> [Mi Jan 30 19:18:01 2019] audit: type=3D2000 audit(1548872280.468:1):
> initialized
> [Mi Jan 30 19:18:01 2019] workingset: timestamp_bits=3D40 max_order=3D20
> bucket_order=3D0
> [Mi Jan 30 19:18:01 2019] zbud: loaded
> [Mi Jan 30 19:18:01 2019] Block layer SCSI generic (bsg) driver version
> 0.4 loaded (major 250)
> [Mi Jan 30 19:18:01 2019] io scheduler noop registered
> [Mi Jan 30 19:18:01 2019] io scheduler deadline registered
> [Mi Jan 30 19:18:01 2019] io scheduler cfq registered (default)
> [Mi Jan 30 19:18:01 2019] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [Mi Jan 30 19:18:01 2019] pciehp: PCI Express Hot Plug Controller Driver
> version: 0.4
> [Mi Jan 30 19:18:01 2019] intel_idle: MWAIT substates: 0x11142120
> [Mi Jan 30 19:18:01 2019] intel_idle: v0.4.1 model 0x3D
> [Mi Jan 30 19:18:01 2019] intel_idle: lapic_timer_reliable_states 0xfffff=
fff
> [Mi Jan 30 19:18:01 2019] GHES: HEST is not enabled!
> [Mi Jan 30 19:18:01 2019] Serial: 8250/16550 driver, 4 ports, IRQ
> sharing enabled
> [Mi Jan 30 19:18:01 2019] Linux agpgart interface v0.103
> [Mi Jan 30 19:18:01 2019] AMD IOMMUv2 driver by Joerg Roedel
> <jroedel@suse.de>
> [Mi Jan 30 19:18:01 2019] AMD IOMMUv2 functionality not available on
> this system
> [Mi Jan 30 19:18:01 2019] i8042: PNP: No PS/2 controller found. Probing
> ports directly.
> [Mi Jan 30 19:18:01 2019] serio: i8042 KBD port at 0x60,0x64 irq 1
> [Mi Jan 30 19:18:01 2019] serio: i8042 AUX port at 0x60,0x64 irq 12
> [Mi Jan 30 19:18:01 2019] mousedev: PS/2 mouse device common for all mice
> [Mi Jan 30 19:18:01 2019] rtc_cmos 00:03: RTC can wake from S4
> [Mi Jan 30 19:18:01 2019] rtc_cmos 00:03: rtc core: registered rtc_cmos
> as rtc0
> [Mi Jan 30 19:18:01 2019] rtc_cmos 00:03: alarms up to one month, y3k,
> 242 bytes nvram, hpet irqs
> [Mi Jan 30 19:18:01 2019] intel_pstate: Intel P-state driver initializing
> [Mi Jan 30 19:18:01 2019] ledtrig-cpu: registered to indicate activity
> on CPUs
> [Mi Jan 30 19:18:01 2019] NET: Registered protocol family 10
> [Mi Jan 30 19:18:01 2019] mip6: Mobile IPv6
> [Mi Jan 30 19:18:01 2019] NET: Registered protocol family 17
> [Mi Jan 30 19:18:01 2019] mpls_gso: MPLS GSO support
> [Mi Jan 30 19:18:01 2019] microcode: sig=3D0x306d4, pf=3D0x40, revision=
=3D0x2b
> [Mi Jan 30 19:18:01 2019] microcode: Microcode Update Driver: v2.01
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [Mi Jan 30 19:18:01 2019] registered taskstats version 1
> [Mi Jan 30 19:18:01 2019] zswap: loaded using pool lzo/zbud
> [Mi Jan 30 19:18:01 2019] ima: No TPM chip found, activating TPM-bypass!
> [Mi Jan 30 19:18:01 2019] ima: Allocated hash algorithm: sha256
> [Mi Jan 30 19:18:01 2019] rtc_cmos 00:03: setting system clock to
> 2019-01-30 18:18:01 UTC (1548872281)
> [Mi Jan 30 19:18:01 2019] PM: Hibernation image not present or could not
> be loaded.
> [Mi Jan 30 19:18:01 2019] Freeing unused kernel memory: 1420K
> [Mi Jan 30 19:18:01 2019] Write protecting the kernel read-only data: 122=
88k
> [Mi Jan 30 19:18:01 2019] Freeing unused kernel memory: 1908K
> [Mi Jan 30 19:18:01 2019] Freeing unused kernel memory: 1224K
> [Mi Jan 30 19:18:01 2019] x86/mm: Checked W+X mappings: passed, no W+X
> pages found.
> [Mi Jan 30 19:18:01 2019] input: Sleep Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
> [Mi Jan 30 19:18:01 2019] ACPI: Sleep Button [SLPB]
> [Mi Jan 30 19:18:01 2019] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
> [Mi Jan 30 19:18:01 2019] ACPI: Power Button [PWRB]
> [Mi Jan 30 19:18:01 2019] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
> [Mi Jan 30 19:18:01 2019] ACPI: Power Button [PWRF]
> [Mi Jan 30 19:18:01 2019] ACPI: bus type USB registered
> [Mi Jan 30 19:18:01 2019] [drm] Initialized
> [Mi Jan 30 19:18:01 2019] usbcore: registered new interface driver usbfs
> [Mi Jan 30 19:18:01 2019] usbcore: registered new interface driver hub
> [Mi Jan 30 19:18:01 2019] SCSI subsystem initialized
> [Mi Jan 30 19:18:01 2019] usbcore: registered new device driver usb
> [Mi Jan 30 19:18:01 2019] thermal LNXTHERM:00: registered as thermal_zone=
0
> [Mi Jan 30 19:18:01 2019] ACPI: Thermal Zone [TZ00] (28 C)
> [Mi Jan 30 19:18:01 2019] thermal LNXTHERM:01: registered as thermal_zone=
1
> [Mi Jan 30 19:18:01 2019] ACPI: Thermal Zone [TZ01] (30 C)
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: new USB bus registered,
> assigned bus number 1
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: hcc params 0x200077c1
> hci version 0x100 quirks 0x0004b810
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: cache line size of 64
> is not supported
> [Mi Jan 30 19:18:01 2019] usb usb1: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0002
> [Mi Jan 30 19:18:01 2019] usb usb1: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:18:01 2019] usb usb1: Product: xHCI Host Controller
> [Mi Jan 30 19:18:01 2019] usb usb1: Manufacturer: Linux 4.9.0-8-amd64
> xhci-hcd
> [Mi Jan 30 19:18:01 2019] usb usb1: SerialNumber: 0000:00:14.0
> [Mi Jan 30 19:18:01 2019] libata version 3.00 loaded.
> [Mi Jan 30 19:18:01 2019] hub 1-0:1.0: USB hub found
> [Mi Jan 30 19:18:01 2019] hub 1-0:1.0: 11 ports detected
> [Mi Jan 30 19:18:01 2019] AVX2 version of gcm_enc/dec engaged.
> [Mi Jan 30 19:18:01 2019] AES CTR mode by8 optimization enabled
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [Mi Jan 30 19:18:01 2019] xhci_hcd 0000:00:14.0: new USB bus registered,
> assigned bus number 2
> [Mi Jan 30 19:18:01 2019] usb usb2: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0003
> [Mi Jan 30 19:18:01 2019] usb usb2: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:18:01 2019] usb usb2: Product: xHCI Host Controller
> [Mi Jan 30 19:18:01 2019] usb usb2: Manufacturer: Linux 4.9.0-8-amd64
> xhci-hcd
> [Mi Jan 30 19:18:01 2019] usb usb2: SerialNumber: 0000:00:14.0
> [Mi Jan 30 19:18:01 2019] hub 2-0:1.0: USB hub found
> [Mi Jan 30 19:18:01 2019] hub 2-0:1.0: 4 ports detected
> [Mi Jan 30 19:18:01 2019] ahci 0000:00:1f.2: version 3.0
> [Mi Jan 30 19:18:01 2019] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4
> ports 6 Gbps 0x1 impl SATA mode
> [Mi Jan 30 19:18:01 2019] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo
> only pio slum part deso sadm sds apst
> [Mi Jan 30 19:18:01 2019] scsi host0: ahci
> [Mi Jan 30 19:18:01 2019] scsi host1: ahci
> [Mi Jan 30 19:18:01 2019] scsi host2: ahci
> [Mi Jan 30 19:18:01 2019] scsi host3: ahci
> [Mi Jan 30 19:18:01 2019] ata1: SATA max UDMA/133 abar m2048@0x9a039000
> port 0x9a039100 irq 43
> [Mi Jan 30 19:18:01 2019] ata2: DUMMY
> [Mi Jan 30 19:18:01 2019] ata3: DUMMY
> [Mi Jan 30 19:18:01 2019] ata4: DUMMY
> [Mi Jan 30 19:18:01 2019] [drm] Memory usable by graphics device =3D 4096=
M
> [Mi Jan 30 19:18:01 2019] [drm] Replacing VGA console driver
> [Mi Jan 30 19:18:01 2019] Console: switching to colour dummy device 80x25
> [Mi Jan 30 19:18:01 2019] [drm] Supports vblank timestamp caching Rev 2
> (21.10.2013).
> [Mi Jan 30 19:18:01 2019] [drm] Driver supports precise vblank timestamp
> query.
> [Mi Jan 30 19:18:01 2019] vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> [Mi Jan 30 19:18:01 2019] ACPI: Video Device [GFX0] (multi-head: yes
> rom: no  post: no)
> [Mi Jan 30 19:18:01 2019] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
> [Mi Jan 30 19:18:01 2019] [drm] Initialized i915 1.6.0 20160919 for
> 0000:00:02.0 on minor 0
> [Mi Jan 30 19:18:02 2019] fbcon: inteldrmfb (fb0) is primary device
> [Mi Jan 30 19:18:02 2019] Console: switching to colour frame buffer
> device 240x67
> [Mi Jan 30 19:18:02 2019] i915 0000:00:02.0: fb0: inteldrmfb frame
> buffer device
> [Mi Jan 30 19:18:02 2019] usb 1-2: new full-speed USB device number 2
> using xhci_hcd
> [Mi Jan 30 19:18:02 2019] ata1: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> [Mi Jan 30 19:18:02 2019] ata1.00: ATA-10: ST2000LX001-1RG174, SDM1, max
> UDMA/133
> [Mi Jan 30 19:18:02 2019] ata1.00: 3907029168 sectors, multi 16: LBA48
> NCQ (depth 31/32), AA
> [Mi Jan 30 19:18:02 2019] usb 1-2: New USB device found, idVendor=3D046d,
> idProduct=3Dc52b
> [Mi Jan 30 19:18:02 2019] usb 1-2: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D0
> [Mi Jan 30 19:18:02 2019] usb 1-2: Product: USB Receiver
> [Mi Jan 30 19:18:02 2019] usb 1-2: Manufacturer: Logitech
> [Mi Jan 30 19:18:02 2019] ata1.00: configured for UDMA/133
> [Mi Jan 30 19:18:02 2019] scsi 0:0:0:0: Direct-Access     ATA
> ST2000LX001-1RG1 SDM1 PQ: 0 ANSI: 5
> [Mi Jan 30 19:18:02 2019] tsc: Refined TSC clocksource calibration:
> 2095.152 MHz
> [Mi Jan 30 19:18:02 2019] clocksource: tsc: mask: 0xffffffffffffffff
> max_cycles: 0x1e334ca44a8, max_idle_ns: 440795209927 ns
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] 3907029168 512-byte logical
> blocks: (2.00 TB/1.82 TiB)
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] Write Protect is off
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] Write cache: enabled, read
> cache: enabled, doesn't support DPO or FUA
> [Mi Jan 30 19:18:02 2019]  sda: sda1 sda2 < sda5 > sda3 sda4
> [Mi Jan 30 19:18:02 2019] sd 0:0:0:0: [sda] Attached SCSI disk
> [Mi Jan 30 19:18:02 2019] usb 1-3: new high-speed USB device number 3
> using xhci_hcd
> [Mi Jan 30 19:18:02 2019] random: fast init done
> [Mi Jan 30 19:18:02 2019] usb 1-3: New USB device found, idVendor=3D0b48,
> idProduct=3D3014
> [Mi Jan 30 19:18:02 2019] usb 1-3: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D3
> [Mi Jan 30 19:18:02 2019] usb 1-3: Product: TechnoTrend USB-Stick
> [Mi Jan 30 19:18:02 2019] usb 1-3: Manufacturer: CityCom GmbH
> [Mi Jan 30 19:18:02 2019] usb 1-3: SerialNumber: 20131128
> [Mi Jan 30 19:18:02 2019] usb 1-4: new high-speed USB device number 4
> using xhci_hcd
> [Mi Jan 30 19:18:02 2019] usb 1-4: New USB device found, idVendor=3D2659,
> idProduct=3D1210
> [Mi Jan 30 19:18:02 2019] usb 1-4: New USB device strings: Mfr=3D1,
> Product=3D2, SerialNumber=3D3
> [Mi Jan 30 19:18:02 2019] usb 1-4: Product: MediaTV Pro III (EU)
> [Mi Jan 30 19:18:02 2019] usb 1-4: Manufacturer: Sundtek
> [Mi Jan 30 19:18:02 2019] usb 1-4: SerialNumber: U150624171804
> [Mi Jan 30 19:18:02 2019] hidraw: raw HID events driver (C) Jiri Kosina
> [Mi Jan 30 19:18:02 2019] usbcore: registered new interface driver usbhid
> [Mi Jan 30 19:18:02 2019] usbhid: USB HID core driver
> [Mi Jan 30 19:18:02 2019] logitech-djreceiver 0003:046D:C52B.0003:
> hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:14.0-2/input2
> [Mi Jan 30 19:18:03 2019] device-mapper: uevent: version 1.0.3
> [Mi Jan 30 19:18:03 2019] device-mapper: ioctl: 4.35.0-ioctl
> (2016-06-23) initialised: dm-devel@redhat.com
> [Mi Jan 30 19:18:03 2019] random: lvm: uninitialized urandom read (4
> bytes read)
> [Mi Jan 30 19:18:03 2019] random: lvm: uninitialized urandom read (4
> bytes read)
> [Mi Jan 30 19:18:03 2019] clocksource: Switched to clocksource tsc
> [Mi Jan 30 19:18:03 2019] input: Logitech K400 Plus as
> /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/000=
3:046D:404D.0004/input/input7
> [Mi Jan 30 19:18:03 2019] logitech-hidpp-device 0003:046D:404D.0004:
> input,hidraw1: USB HID v1.11 Keyboard [Logitech K400 Plus] on
> usb-0000:00:14.0-2:1
> [Mi Jan 30 19:18:10 2019] random: cryptsetup: uninitialized urandom read
> (2 bytes read)
> [Mi Jan 30 19:18:10 2019] random: cryptsetup: uninitialized urandom read
> (2 bytes read)
> [Mi Jan 30 19:18:10 2019] random: cryptsetup: uninitialized urandom read
> (2 bytes read)
> [Mi Jan 30 19:18:10 2019] random: crng init done
> [Mi Jan 30 19:18:11 2019] PM: Starting manual resume from disk
> [Mi Jan 30 19:18:11 2019] PM: Hibernation image partition 254:2 present
> [Mi Jan 30 19:18:11 2019] PM: Looking for hibernation image.
> [Mi Jan 30 19:18:11 2019] PM: Image not found (code -22)
> [Mi Jan 30 19:18:11 2019] PM: Hibernation image not present or could not
> be loaded.
> [Mi Jan 30 19:18:11 2019] EXT4-fs (dm-1): mounted filesystem with
> ordered data mode. Opts: (null)
> [Mi Jan 30 19:18:11 2019] systemd[1]: Inserted module 'autofs4'
> [Mi Jan 30 19:18:11 2019] ip_tables: (C) 2000-2006 Netfilter Core Team
> [Mi Jan 30 19:18:11 2019] cgroup: cgroup2: unknown option "nsdelegate"
> [Mi Jan 30 19:18:11 2019] systemd[1]: systemd 240 running in system
> mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP
> +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS
> +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=3Dhybrid)
> [Mi Jan 30 19:18:11 2019] systemd[1]: Detected architecture x86-64.
> [Mi Jan 30 19:18:11 2019] systemd[1]: Set hostname to <media-box>.
> [Mi Jan 30 19:18:12 2019] systemd[1]: File
> /lib/systemd/system/systemd-journald.service:12 configures an IP
> firewall (IPAddressDeny=3Dany), but the local system does not support
> BPF/cgroup based firewalling.
> [Mi Jan 30 19:18:12 2019] systemd[1]: Proceeding WITHOUT firewalling in
> effect! (This warning is only shown for the first loaded unit using IP
> firewalling.)
> [Mi Jan 30 19:18:12 2019] systemd[1]:
> /lib/systemd/system/smbd.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/samba/smbd.pid =E2=86=92
> /run/samba/smbd.pid; please update the unit file accordingly.
> [Mi Jan 30 19:18:12 2019] systemd[1]:
> /lib/systemd/system/nmbd.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/samba/nmbd.pid =E2=86=92
> /run/samba/nmbd.pid; please update the unit file accordingly.
> [Mi Jan 30 19:18:12 2019] systemd[1]:
> /lib/systemd/system/dovecot.service:9: PIDFile=3D references path below
> legacy directory /var/run/, updating /var/run/dovecot/master.pid =E2=86=
=92
> /run/dovecot/master.pid; please update the unit file accordingly.
> [Mi Jan 30 19:18:12 2019] systemd[1]: Started Forward Password Requests
> to Wall Directory Watch.
> [Mi Jan 30 19:18:12 2019] systemd[1]: Listening on Device-mapper event
> daemon FIFOs.
> [Mi Jan 30 19:18:12 2019] EXT4-fs (dm-1): re-mounted. Opts:
> errors=3Dremount-ro
> [Mi Jan 30 19:18:12 2019] RPC: Registered named UNIX socket transport
> module.
> [Mi Jan 30 19:18:12 2019] RPC: Registered udp transport module.
> [Mi Jan 30 19:18:12 2019] RPC: Registered tcp transport module.
> [Mi Jan 30 19:18:12 2019] RPC: Registered tcp NFSv4.1 backchannel
> transport module.
> [Mi Jan 30 19:18:12 2019] ehci_hcd: USB 2.0 'Enhanced' Host Controller
> (EHCI) Driver
> [Mi Jan 30 19:18:12 2019] ehci-pci: EHCI PCI platform driver
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: new USB bus registered,
> assigned bus number 3
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: debug port 2
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: cache line size of 64
> is not supported
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: irq 23, io mem 0x9a03a00=
0
> [Mi Jan 30 19:18:12 2019] systemd-journald[327]: Received request to
> flush runtime journal from PID 1
> [Mi Jan 30 19:18:12 2019] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.=
00
> [Mi Jan 30 19:18:12 2019] usb usb3: New USB device found, idVendor=3D1d6b=
,
> idProduct=3D0002
> [Mi Jan 30 19:18:12 2019] usb usb3: New USB device strings: Mfr=3D3,
> Product=3D2, SerialNumber=3D1
> [Mi Jan 30 19:18:12 2019] usb usb3: Product: EHCI Host Controller
> [Mi Jan 30 19:18:12 2019] usb usb3: Manufacturer: Linux 4.9.0-8-amd64
> ehci_hcd
> [Mi Jan 30 19:18:12 2019] usb usb3: SerialNumber: 0000:00:1d.0
> [Mi Jan 30 19:18:12 2019] hub 3-0:1.0: USB hub found
> [Mi Jan 30 19:18:12 2019] hub 3-0:1.0: 2 ports detected
> [Mi Jan 30 19:18:13 2019] usb 3-1: new high-speed USB device number 2
> using ehci-pci
> [Mi Jan 30 19:18:13 2019] Installing knfsd (copyright (C) 1996
> okir@monad.swb.de).
> [Mi Jan 30 19:18:13 2019] usb 3-1: New USB device found, idVendor=3D8087,
> idProduct=3D8001
> [Mi Jan 30 19:18:13 2019] usb 3-1: New USB device strings: Mfr=3D0,
> Product=3D0, SerialNumber=3D0
> [Mi Jan 30 19:18:13 2019] hub 3-1:1.0: USB hub found
> [Mi Jan 30 19:18:13 2019] hub 3-1:1.0: 8 ports detected
> [Mi Jan 30 19:18:13 2019] RAPL PMU: API unit is 2^-32 Joules, 4 fixed
> counters, 655360 ms ovfl timer
> [Mi Jan 30 19:18:13 2019] RAPL PMU: hw unit of domain pp0-core 2^-14 Joul=
es
> [Mi Jan 30 19:18:13 2019] RAPL PMU: hw unit of domain package 2^-14 Joule=
s
> [Mi Jan 30 19:18:13 2019] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [Mi Jan 30 19:18:13 2019] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joule=
s
> [Mi Jan 30 19:18:13 2019] input: PC Speaker as
> /devices/platform/pcspkr/input/input8
> [Mi Jan 30 19:18:13 2019] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [Mi Jan 30 19:18:13 2019] pps_core: LinuxPPS API ver. 1 registered
> [Mi Jan 30 19:18:13 2019] pps_core: Software ver. 5.3.6 - Copyright
> 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [Mi Jan 30 19:18:13 2019] nuvoton-cir 00:01: found NCT6776F or
> compatible: chip id: 0xc3 0x33
> [Mi Jan 30 19:18:14 2019] PTP clock support registered
> [Mi Jan 30 19:18:14 2019] i801_smbus 0000:00:1f.3: SPD Write Disable is s=
et
> [Mi Jan 30 19:18:14 2019] i801_smbus 0000:00:1f.3: SMBus using PCI interr=
upt
> [Mi Jan 30 19:18:14 2019] iTCO_vendor_support: vendor-support=3D0
> [Mi Jan 30 19:18:14 2019] Registered IR keymap rc-rc6-mce
> [Mi Jan 30 19:18:14 2019] input: Nuvoton w836x7hg Infrared Remote
> Transceiver as /devices/pnp0/00:01/rc/rc0/input9
> [Mi Jan 30 19:18:14 2019] rc rc0: Nuvoton w836x7hg Infrared Remote
> Transceiver as /devices/pnp0/00:01/rc/rc0
> [Mi Jan 30 19:18:14 2019] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.=
6-k
> [Mi Jan 30 19:18:14 2019] e1000e: Copyright(c) 1999 - 2015 Intel
> Corporation.
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0: Interrupt Throttling Rate
> (ints/sec) set to dynamic conservative mode
> [Mi Jan 30 19:18:14 2019] lirc_dev: IR Remote Control driver registered,
> major 245
> [Mi Jan 30 19:18:14 2019] IR RC6 protocol handler initialized
> [Mi Jan 30 19:18:14 2019] rc rc0: lirc_dev: driver ir-lirc-codec
> (nuvoton-cir) registered at minor =3D 0
> [Mi Jan 30 19:18:14 2019] IR LIRC bridge handler initialized
> [Mi Jan 30 19:18:14 2019] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [Mi Jan 30 19:18:14 2019] iTCO_wdt: Found a Wildcat Point_LP TCO device
> (Version=3D2, TCOBASE=3D0x1860)
> [Mi Jan 30 19:18:14 2019] iTCO_wdt: initialized. heartbeat=3D30 sec
> (nowayout=3D0)
> [Mi Jan 30 19:18:14 2019] nuvoton-cir 00:01: driver has been
> successfully loaded
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0 0000:00:19.0
> (uninitialized): registered PHC clock
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0 eth0: (PCI
> Express:2.5GT/s:Width x1) b8:ae:ed:72:db:9c
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000
> Network Connection
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12,
> PBA No: FFFFFF-0FF
> [Mi Jan 30 19:18:14 2019] e1000e 0000:00:19.0 enp0s25: renamed from eth0
> [Mi Jan 30 19:18:14 2019] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0
> (ops i915_audio_component_bind_ops [i915])
> [Mi Jan 30 19:18:14 2019] Adding 4194300k swap on
> /dev/mapper/cryptvol-swap.  Priority:-1 extents:1 across:4194300k FS
> [Mi Jan 30 19:18:14 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D3 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input10
> [Mi Jan 30 19:18:14 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D7 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input11
> [Mi Jan 30 19:18:14 2019] input: HDA Intel HDMI HDMI/DP,pcm=3D8 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input12
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0: autoconfig
> for ALC283: line_outs=3D1 (0x21/0x0/0x0/0x0/0x0) type:hp
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0:
> speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0: hp_outs=3D0
> (0x0/0x0/0x0/0x0/0x0)
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0: mono:
> mono_out=3D0x0
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0: inputs:
> [Mi Jan 30 19:18:14 2019] snd_hda_codec_realtek hdaudioC1D0: Mic=3D0x19
> [Mi Jan 30 19:18:14 2019] input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
> [Mi Jan 30 19:18:14 2019] input: HDA Intel PCH Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
> [Mi Jan 30 19:18:14 2019] input: HDA Intel PCH Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
> [Mi Jan 30 19:18:14 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend
> TVStick CT2-4400' in warm state
> [Mi Jan 30 19:18:14 2019] usb 1-3: dvb_usb_v2: will pass the complete
> MPEG2 transport stream to the software demuxer
> [Mi Jan 30 19:18:14 2019] DVB: registering new adapter (TechnoTrend
> TVStick CT2-4400)
> [Mi Jan 30 19:18:14 2019] usb 1-3: dvb_usb_v2: MAC address:
> bc:ea:2b:44:0f:89
> [Mi Jan 30 19:18:14 2019] intel_rapl: Found RAPL domain package
> [Mi Jan 30 19:18:14 2019] intel_rapl: Found RAPL domain core
> [Mi Jan 30 19:18:14 2019] intel_rapl: Found RAPL domain uncore
> [Mi Jan 30 19:18:14 2019] intel_rapl: Found RAPL domain dram
> [Mi Jan 30 19:18:15 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan 30 19:18:15 2019] si2168 6-0064: Silicon Labs Si2168-B40
> successfully identified
> [Mi Jan 30 19:18:15 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan 30 19:18:15 2019] media: Linux media interface: v0.10
> [Mi Jan 30 19:18:15 2019] si2157 7-0060: Silicon Labs
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan 30 19:18:15 2019] usb 1-3: DVB: registering adapter 0 frontend 0
> (Silicon Labs Si2168)...
> [Mi Jan 30 19:18:15 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick
> CT2-4400' successfully initialized and connected
> [Mi Jan 30 19:18:15 2019] usbcore: registered new interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:18:15 2019] EXT4-fs (sda1): mounted filesystem with
> ordered data mode. Opts: (null)
> [Mi Jan 30 19:18:15 2019] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is
> not ready
> [Mi Jan 30 19:18:18 2019] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full
> Duplex, Flow Control: Rx/Tx
> [Mi Jan 30 19:18:18 2019] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: link
> becomes ready
> [Mi Jan 30 19:18:22 2019] input: Sundtek Remote Control as
> /devices/virtual/input/input16
> [Mi Jan 30 19:18:23 2019] NFSD: Using /var/lib/nfs/v4recovery as the
> NFSv4 state recovery directory
> [Mi Jan 30 19:18:23 2019] NFSD: starting 90-second grace period (net
> ffffffff97edbe80)
> [Mi Jan 30 19:18:27 2019] si2168 6-0064: firmware: direct-loading
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan 30 19:18:27 2019] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan 30 19:18:28 2019] si2168 6-0064: firmware version: B 4.0.11
> [Mi Jan 30 19:18:28 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30=
'
> [Mi Jan 30 19:18:28 2019] si2157 7-0060: firmware version: 3.0.5
> [Mi Jan 30 19:18:29 2019] fuse init (API version 7.26)
> [Mi Jan 30 19:19:28 2019] usb 1-4: usbfs: process 800 (mediasrv) did not
> claim interface 2 before use
> [Mi Jan 30 19:22:41 2019] usbcore: deregistering interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:22:41 2019] dvb_usb_v2: 'TechnoTrend TVStick CT2-4400:1-3'
> successfully deinitialized and disconnected
> [Mi Jan 30 19:22:41 2019] PM: Syncing filesystems ... done.
> [Mi Jan 30 19:22:41 2019] PM: Preparing system for sleep (mem)
> [Mi Jan 30 19:22:41 2019] Freezing user space processes ... (elapsed
> 0.001 seconds) done.
> [Mi Jan 30 19:22:41 2019] Freezing remaining freezable tasks ...
> (elapsed 0.001 seconds) done.
> [Mi Jan 30 19:22:41 2019] PM: Suspending system (mem)
> [Mi Jan 30 19:22:41 2019] Suspending console(s) (use no_console_suspend
> to debug)
> [Mi Jan 30 19:22:41 2019] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [Mi Jan 30 19:22:41 2019] nuvoton-cir 00:01: disabled
> [Mi Jan 30 19:22:41 2019] e1000e: EEE TX LPI TIMER: 00000011
> [Mi Jan 30 19:22:41 2019] sd 0:0:0:0: [sda] Stopping disk
> [Mi Jan 30 19:22:42 2019] PM: suspend of devices complete after 683.790
> msecs
> [Mi Jan 30 19:22:42 2019] PM: late suspend of devices complete after
> 19.288 msecs
> [Mi Jan 30 19:22:42 2019] ehci-pci 0000:00:1d.0: System wakeup enabled
> by ACPI
> [Mi Jan 30 19:22:42 2019] e1000e 0000:00:19.0: System wakeup enabled by A=
CPI
> [Mi Jan 30 19:22:42 2019] xhci_hcd 0000:00:14.0: System wakeup enabled
> by ACPI
> [Mi Jan 30 19:22:42 2019] PM: noirq suspend of devices complete after
> 19.880 msecs
> [Mi Jan 30 19:22:42 2019] ACPI: Preparing to enter system sleep state S3
> [Mi Jan 30 19:22:42 2019] PM: Saving platform NVS memory
> [Mi Jan 30 19:22:42 2019] Disabling non-boot CPUs ...
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 43
> [Mi Jan 30 19:22:42 2019] smpboot: CPU 1 is now offline
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 43
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 44
> [Mi Jan 30 19:22:42 2019] smpboot: CPU 2 is now offline
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 42
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 43
> [Mi Jan 30 19:22:42 2019] Broke affinity for irq 44
> [Mi Jan 30 19:22:42 2019] smpboot: CPU 3 is now offline
> [Mi Jan 30 19:22:42 2019] ACPI: Low-level resume complete
> [Mi Jan 30 19:22:42 2019] PM: Restoring platform NVS memory
> [Mi Jan 30 19:22:42 2019] Suspended for 36.855 seconds
> [Mi Jan 30 19:22:42 2019] Enabling non-boot CPUs ...
> [Mi Jan 30 19:22:42 2019] x86: Booting SMP configuration:
> [Mi Jan 30 19:22:42 2019] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [Mi Jan 30 19:22:42 2019]  cache: parent cpu1 should not be sleeping
> [Mi Jan 30 19:22:42 2019] CPU1 is up
> [Mi Jan 30 19:22:42 2019] smpboot: Booting Node 0 Processor 2 APIC 0x1
> [Mi Jan 30 19:22:42 2019]  cache: parent cpu2 should not be sleeping
> [Mi Jan 30 19:22:42 2019] CPU2 is up
> [Mi Jan 30 19:22:42 2019] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [Mi Jan 30 19:22:42 2019]  cache: parent cpu3 should not be sleeping
> [Mi Jan 30 19:22:42 2019] CPU3 is up
> [Mi Jan 30 19:22:42 2019] ACPI: Waking up from system sleep state S3
> [Mi Jan 30 19:22:42 2019] xhci_hcd 0000:00:14.0: System wakeup disabled
> by ACPI
> [Mi Jan 30 19:22:42 2019] ehci-pci 0000:00:1d.0: System wakeup disabled
> by ACPI
> [Mi Jan 30 19:22:42 2019] PM: noirq resume of devices complete after
> 20.933 msecs
> [Mi Jan 30 19:22:42 2019] hpet1: lost 1205 rtc interrupts
> [Mi Jan 30 19:22:42 2019] PM: early resume of devices complete after
> 1.096 msecs
> [Mi Jan 30 19:22:42 2019] e1000e 0000:00:19.0: System wakeup disabled by
> ACPI
> [Mi Jan 30 19:22:42 2019] nuvoton-cir 00:01: System wakeup disabled by AC=
PI
> [Mi Jan 30 19:22:42 2019] sd 0:0:0:0: [sda] Starting disk
> [Mi Jan 30 19:22:42 2019] nuvoton-cir 00:01: activated
> [Mi Jan 30 19:22:42 2019] rtc_cmos 00:03: System wakeup disabled by ACPI
> [Mi Jan 30 19:22:42 2019] ata1: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> [Mi Jan 30 19:22:42 2019] ata1.00: configured for UDMA/133
> [Mi Jan 30 19:22:43 2019] PM: resume of devices complete after 1558.206
> msecs
> [Mi Jan 30 19:22:43 2019] PM: Finishing wakeup.
> [Mi Jan 30 19:22:43 2019] Restarting tasks ... done.
> [Mi Jan 30 19:22:44 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend
> TVStick CT2-4400' in warm state
> [Mi Jan 30 19:22:44 2019] usb 1-3: dvb_usb_v2: will pass the complete
> MPEG2 transport stream to the software demuxer
> [Mi Jan 30 19:22:44 2019] DVB: registering new adapter (TechnoTrend
> TVStick CT2-4400)
> [Mi Jan 30 19:22:44 2019] usb 1-3: dvb_usb_v2: MAC address:
> bc:ea:2b:44:0f:89
> [Mi Jan 30 19:22:44 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan 30 19:22:44 2019] si2168 6-0064: Silicon Labs Si2168-B40
> successfully identified
> [Mi Jan 30 19:22:44 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan 30 19:22:44 2019] si2157 7-0060: Silicon Labs
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan 30 19:22:44 2019] usb 1-3: DVB: registering adapter 0 frontend 0
> (Silicon Labs Si2168)...
> [Mi Jan 30 19:22:44 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick
> CT2-4400' successfully initialized and connected
> [Mi Jan 30 19:22:44 2019] usbcore: registered new interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:22:46 2019] si2168 6-0064: firmware: direct-loading
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan 30 19:22:46 2019] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan 30 19:22:46 2019] si2168 6-0064: firmware version: B 4.0.11
> [Mi Jan 30 19:22:46 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30=
'
> [Mi Jan 30 19:22:46 2019] si2157 7-0060: firmware version: 3.0.5
> [Mi Jan 30 19:22:47 2019] e1000e: enp0s25 NIC Link is Up 10 Mbps Full
> Duplex, Flow Control: Rx/Tx
> [Mi Jan 30 19:22:47 2019] e1000e 0000:00:19.0 enp0s25: 10/100 speed:
> disabling TSO
> [Mi Jan 30 19:22:54 2019] input: Sundtek Remote Control as
> /devices/virtual/input/input20
> [Mi Jan 30 19:24:01 2019] usbcore: deregistering interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:24:01 2019] dvb_usb_v2: 'TechnoTrend TVStick CT2-4400:1-3'
> successfully deinitialized and disconnected
> [Mi Jan 30 19:24:01 2019] PM: Syncing filesystems ... done.
> [Mi Jan 30 19:24:01 2019] PM: Preparing system for sleep (mem)
> [Mi Jan 30 19:24:01 2019] Freezing user space processes ... (elapsed
> 0.001 seconds) done.
> [Mi Jan 30 19:24:01 2019] Freezing remaining freezable tasks ...
> (elapsed 0.001 seconds) done.
> [Mi Jan 30 19:24:01 2019] PM: Suspending system (mem)
> [Mi Jan 30 19:24:01 2019] Suspending console(s) (use no_console_suspend
> to debug)
> [Mi Jan 30 19:24:01 2019] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [Mi Jan 30 19:24:01 2019] nuvoton-cir 00:01: disabled
> [Mi Jan 30 19:24:01 2019] e1000e: EEE TX LPI TIMER: 00000011
> [Mi Jan 30 19:24:01 2019] sd 0:0:0:0: [sda] Stopping disk
> [Mi Jan 30 19:24:02 2019] PM: suspend of devices complete after 666.858
> msecs
> [Mi Jan 30 19:24:02 2019] PM: late suspend of devices complete after
> 19.191 msecs
> [Mi Jan 30 19:24:02 2019] ehci-pci 0000:00:1d.0: System wakeup enabled
> by ACPI
> [Mi Jan 30 19:24:02 2019] e1000e 0000:00:19.0: System wakeup enabled by A=
CPI
> [Mi Jan 30 19:24:02 2019] xhci_hcd 0000:00:14.0: System wakeup enabled
> by ACPI
> [Mi Jan 30 19:24:02 2019] PM: noirq suspend of devices complete after
> 19.979 msecs
> [Mi Jan 30 19:24:02 2019] ACPI: Preparing to enter system sleep state S3
> [Mi Jan 30 19:24:02 2019] PM: Saving platform NVS memory
> [Mi Jan 30 19:24:02 2019] Disabling non-boot CPUs ...
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 43
> [Mi Jan 30 19:24:02 2019] smpboot: CPU 1 is now offline
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 43
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 44
> [Mi Jan 30 19:24:02 2019] smpboot: CPU 2 is now offline
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 42
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 43
> [Mi Jan 30 19:24:02 2019] Broke affinity for irq 44
> [Mi Jan 30 19:24:02 2019] smpboot: CPU 3 is now offline
> [Mi Jan 30 19:24:02 2019] ACPI: Low-level resume complete
> [Mi Jan 30 19:24:02 2019] PM: Restoring platform NVS memory
> [Mi Jan 30 19:24:02 2019] Suspended for 10.047 seconds
> [Mi Jan 30 19:24:02 2019] Enabling non-boot CPUs ...
> [Mi Jan 30 19:24:02 2019] x86: Booting SMP configuration:
> [Mi Jan 30 19:24:02 2019] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [Mi Jan 30 19:24:02 2019]  cache: parent cpu1 should not be sleeping
> [Mi Jan 30 19:24:02 2019] CPU1 is up
> [Mi Jan 30 19:24:02 2019] smpboot: Booting Node 0 Processor 2 APIC 0x1
> [Mi Jan 30 19:24:02 2019]  cache: parent cpu2 should not be sleeping
> [Mi Jan 30 19:24:02 2019] CPU2 is up
> [Mi Jan 30 19:24:02 2019] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [Mi Jan 30 19:24:02 2019]  cache: parent cpu3 should not be sleeping
> [Mi Jan 30 19:24:02 2019] CPU3 is up
> [Mi Jan 30 19:24:02 2019] ACPI: Waking up from system sleep state S3
> [Mi Jan 30 19:24:02 2019] xhci_hcd 0000:00:14.0: System wakeup disabled
> by ACPI
> [Mi Jan 30 19:24:02 2019] ehci-pci 0000:00:1d.0: System wakeup disabled
> by ACPI
> [Mi Jan 30 19:24:02 2019] PM: noirq resume of devices complete after
> 16.686 msecs
> [Mi Jan 30 19:24:02 2019] PM: early resume of devices complete after
> 0.350 msecs
> [Mi Jan 30 19:24:02 2019] sd 0:0:0:0: [sda] Starting disk
> [Mi Jan 30 19:24:02 2019] e1000e 0000:00:19.0: System wakeup disabled by
> ACPI
> [Mi Jan 30 19:24:02 2019] nuvoton-cir 00:01: System wakeup disabled by AC=
PI
> [Mi Jan 30 19:24:02 2019] nuvoton-cir 00:01: activated
> [Mi Jan 30 19:24:02 2019] rtc_cmos 00:03: System wakeup disabled by ACPI
> [Mi Jan 30 19:24:02 2019] ata1: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> [Mi Jan 30 19:24:02 2019] ata1.00: configured for UDMA/133
> [Mi Jan 30 19:24:02 2019] PM: resume of devices complete after 518.084 ms=
ecs
> [Mi Jan 30 19:24:02 2019] PM: Finishing wakeup.
> [Mi Jan 30 19:24:02 2019] Restarting tasks ... done.
> [Mi Jan 30 19:24:02 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend
> TVStick CT2-4400' in warm state
> [Mi Jan 30 19:24:02 2019] usb 1-3: dvb_usb_v2: will pass the complete
> MPEG2 transport stream to the software demuxer
> [Mi Jan 30 19:24:02 2019] DVB: registering new adapter (TechnoTrend
> TVStick CT2-4400)
> [Mi Jan 30 19:24:02 2019] usb 1-3: dvb_usb_v2: MAC address:
> bc:ea:2b:44:0f:89
> [Mi Jan 30 19:24:02 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan 30 19:24:02 2019] si2168 6-0064: Silicon Labs Si2168-B40
> successfully identified
> [Mi Jan 30 19:24:02 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan 30 19:24:02 2019] si2157 7-0060: Silicon Labs
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan 30 19:24:02 2019] usb 1-3: DVB: registering adapter 0 frontend 0
> (Silicon Labs Si2168)...
> [Mi Jan 30 19:24:02 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick
> CT2-4400' successfully initialized and connected
> [Mi Jan 30 19:24:02 2019] usbcore: registered new interface driver
> dvb_usb_dvbsky
> [Mi Jan 30 19:24:05 2019] si2168 6-0064: firmware: direct-loading
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan 30 19:24:05 2019] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan 30 19:24:05 2019] si2168 6-0064: firmware version: B 4.0.11
> [Mi Jan 30 19:24:05 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30=
'
> [Mi Jan 30 19:24:05 2019] si2157 7-0060: firmware version: 3.0.5
> [Mi Jan 30 19:24:05 2019] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full
> Duplex, Flow Control: Rx/Tx
> [Mi Jan 30 19:24:13 2019] input: Sundtek Remote Control as
> /devices/virtual/input/input24
> [Mi Jan 30 19:25:21 2019] usb 1-4: usbfs: process 3105 (mediasrv) did
> not claim interface 2 before use
>
> Regards, Frank
