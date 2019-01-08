Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C6C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7291C206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfAHNqA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:46:00 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59236 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727670AbfAHNqA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 08:46:00 -0500
Received: from [IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231] ([IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231])
        by smtp-cloud8.xs4all.net with ESMTPA
        id grhbgXWBsNR5ygrhegzXvw; Tue, 08 Jan 2019 14:45:58 +0100
Subject: Re: [PATCH v1 2/2] media: atmel-isc: Update device tree binding
 documentation
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Ken Sloat <KSloat@aampglobal.com>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
Cc:     "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20181228165934.36393-1-ksloat@aampglobal.com>
 <20181228165934.36393-2-ksloat@aampglobal.com>
 <fd9073b4-7625-6f91-546e-9dad0bf6201f@xs4all.nl>
Message-ID: <0be61a88-93c9-6181-b0ea-b1048c98e0e1@xs4all.nl>
Date:   Tue, 8 Jan 2019 14:45:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <fd9073b4-7625-6f91-546e-9dad0bf6201f@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFsI6T5eUbVn8LU8+u2Hp5EO9vvNXgh1YQoHzT9Te4EcVutlQhhEmGTAW/ivTAO7pzLTaQQpZjM/Ssq2qX59PkgFFNS5rSnUdlZz6gzfxGoAbSn/asns
 W4Za6i/ZwTUZvJRLbE7LeKjS/SHp5PPLdUwY0VBu+5enC1m1p5dw+by8l0wlq9J//d53ZhkoK1LcEfxebuYX/HWik2ew5kOLUMHKDyGb++uBGPUc0nyiC/jt
 1fGKixubUp516eg8lEW2q37B9KCA+nDCs8eaj7KI1CNhoclt1MnJGjRakwtbhLLc0GLyQttWDQIzABDdvHjcu3VMI+PvIIqrs5nfnT7vB6qjlcb2Vi1SOImb
 qefv6vAH8FcA3tRcEzXnhNK3gNi96gXCzVN79tm6uF+/lsPozIUuk5FCau4Ao/wik/WwtDB7wzopE1nhShCTut4ZF0l3TiHZh+SRzThmGThavhZurVcklLxz
 gVi6kZLtJpy9uXlSHEoMa2Ve6i7GwISZvSd8PAqLs+r4BgBMEOE9RG25hUg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/08/19 14:44, Hans Verkuil wrote:
> On 12/28/18 17:59, Ken Sloat wrote:
>> From: Ken Sloat <ksloat@aampglobal.com>
>>
>> Update device tree binding documentation specifying how to
>> enable BT656 with CRC decoding.
>>
>> Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
>> ---
>>  Documentation/devicetree/bindings/media/atmel-isc.txt | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Documentation/devicetree/bindings/media/atmel-isc.txt
>> index bbe0e87c6188..e787edeea7da 100644
>> --- a/Documentation/devicetree/bindings/media/atmel-isc.txt
>> +++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
>> @@ -25,6 +25,9 @@ ISC supports a single port node with parallel bus. It should contain one
>>  'port' child node with child 'endpoint' node. Please refer to the bindings
>>  defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
>>  
>> +If all endpoint bus flags (i.e. hsync-active) are omitted, then CCIR656
>> +decoding (embedded sync) with CRC decoding is enabled.
> 
> Sorry, this is wrong. There is a bus-type property defined in video-interfaces.txt
> that you should use to determine whether this is a parallel or a Bt.656 bus.

Actually, that's what your code already does, so it seems this text in the bindings doc
is just plain wrong.

	Hans

> 
> BTW, for v2 also CC this to devicetree@vger.kernel.org, since it has to be reviewed
> by the DT maintainers.
> 
> Regards,
> 
> 	Hans
> 
>> +
>>  Example:
>>  isc: isc@f0008000 {
>>  	compatible = "atmel,sama5d2-isc";
>>
> 

