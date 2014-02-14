Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4949 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBNOqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 09:46:13 -0500
Message-ID: <52FE2C0A.1060105@xs4all.nl>
Date: Fri, 14 Feb 2014 15:45:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 0/5] SDR API - Mirics MSi3101 driver
References: <1392060543-3972-1-git-send-email-crope@iki.fi> <52FE2AD2.4030404@xs4all.nl>
In-Reply-To: <52FE2AD2.4030404@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2014 03:40 PM, Hans Verkuil wrote:
> Hi Antti,
> 
> Just one very tiny thing: in patch 1 in msi3101_template you added this line:
> 
> +	.debug                    = 0,
> 
> Please remove. Fields initialized to 0 should in general be dropped since the
> compiler sets it to 0 already, and eventually the debug field will disappear
> anyway since you can set it by doing echo 1 >/sys/class/video4linux/video0/debug

Sorry, forgot to mention that after making that small change you can add my

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

for these 5 patches.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> On 02/10/2014 08:28 PM, Antti Palosaari wrote:
>> Split / group / merge changes as requested by Hans.
>>
>> Antti
>>
>> Antti Palosaari (5):
>>   msi3101: convert to SDR API
>>   msi001: Mirics MSi001 silicon tuner driver
>>   msi3101: use msi001 tuner driver
>>   MAINTAINERS: add msi001 driver
>>   MAINTAINERS: add msi3101 driver
>>
>>  MAINTAINERS                                 |   20 +
>>  drivers/staging/media/msi3101/Kconfig       |    7 +-
>>  drivers/staging/media/msi3101/Makefile      |    1 +
>>  drivers/staging/media/msi3101/msi001.c      |  499 +++++++++
>>  drivers/staging/media/msi3101/sdr-msi3101.c | 1558 ++++++++++-----------------
>>  5 files changed, 1095 insertions(+), 990 deletions(-)
>>  create mode 100644 drivers/staging/media/msi3101/msi001.c
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

