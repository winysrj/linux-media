Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp43.i.mail.ru ([94.100.177.103]:38963 "EHLO smtp43.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbbFFFDk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 01:03:40 -0400
Received: from [171.33.253.112] (port=39160 helo=unknown)
	by smtp43.i.mail.ru with esmtpa (envelope-from <severe.siberian.man@mail.ru>)
	id 1Z16Ga-0005OA-8D
	for linux-media@vger.kernel.org; Sat, 06 Jun 2015 08:03:37 +0300
Message-ID: <A9A450C95D0047DA969F1F370ED24FE4@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>
Subject: About Si2168 Part, Revision and ROM detection.
Date: Sat, 6 Jun 2015 12:03:29 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Information below was given by a hardware vendor, who uses these demodulators on their dvb-t2 products. As an explanation on our 
questions for Si2168 Linux driver development.
I think it can give more clue with Part, Revision and ROM detection algorithm in Linux driver for that demodulator.

Also, I would like to suggest a following naming method for files containing firmware patches. It's self explaining:
dvb-demod-si2168-a30-rom3_0_2-patch-build3_0_20.fw
dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw.tar.gz
dvb-demod-si2168-b40-rom4_0_2-startup-without-patch-stub.fw
(Stub code to startup B40 without patch at all: 0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00)
I think such naming scheme can help to avoid possible mess with fw patch versions.

Here is a detection code:
NTSTATUS si2168_cmd_part_info(tPART_INFO *part_info)
{
    NTSTATUS ntStatus;

    BYTE cmdBuffer[1] = {Si2168_PART_INFO_CMD};
    BYTE rspBuffer[13] = {0};

    ntStatus = si2168_cmd_rsp(cmdBuffer, sizeof(cmdBuffer), rspBuffer, sizeof(rspBuffer));
    if (ntStatus != STATUS_SUCCESS)
        return ntStatus;

    part_info->chiprev = rspBuffer[1] & 0x0F;
    part_info->part = rspBuffer[2];
    part_info->pmajor = rspBuffer[3];
    part_info->pminor = rspBuffer[4];
    part_info->pbuild = rspBuffer[5];
    part_info->serial = ((ULONG)rspBuffer[11] << 24) | ((ULONG)rspBuffer[10] << 16) | ((ULONG)rspBuffer[9] << 8) | 
((ULONG)rspBuffer[8]);
    part_info->romid = rspBuffer[12];

    DBGPRINT(("CHIP REV   : %d\n", part_info->chiprev));
    DBGPRINT(("CHIP PART  : %d\n", part_info->part));
    DBGPRINT(("CHIP PMAJOR: %c\n", part_info->pmajor));
    DBGPRINT(("CHIP PMINOR: %c\n", part_info->pminor));
    DBGPRINT(("CHIP PBUILD: %d\n", part_info->pbuild));
    DBGPRINT(("CHIP SERIAL: %08X\n", part_info->serial ));
    DBGPRINT(("CHIP ROMID : %d\n", part_info->romid));

    return STATUS_SUCCESS;
}

Best regards. 

