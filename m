Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3HTMd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 08:33:29 -0400
Message-ID: <52136212.2040504@redhat.com>
Date: Tue, 20 Aug 2013 14:33:22 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] introduce gspca-stk1135: Syntek STK1135 driver
References: <201308112105.00553.linux@rainbow-software.org> <52135F1E.2070909@redhat.com>
In-Reply-To: <52135F1E.2070909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/20/2013 02:20 PM, Hans de Goede wrote:
> Hi,
>
> Thanks for the new version I've added this to my "gspca" tree, and this
> will be included in my next pull-request to Mauro for 3.12

Ugh, correction. I've reverted this patch since stk1135.h is missing
from the patch, can you please send a v3 with stk1135.h added (or just
a mail with stk1135.h attached will be fine too) ASAP, I really would
like to get a pull-req out to Mauro soon.

Regards,

Hans
