Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:47723 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934139AbeF0Juz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 05:50:55 -0400
Subject: Re: [PATCH v4 6/8] media: imx274: add helper function to fill a reg_8
 table chunk
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
 <1528716939-17015-7-git-send-email-luca@lucaceresoli.net>
 <20180626122053.gd5jmt2wr35s5oh2@valkosipuli.retiisi.org.uk>
 <fb7bb663-0708-8271-8f4a-fff906c7babc@lucaceresoli.net>
 <20180627093055.fn6gqpaodzxmhhx3@valkosipuli.retiisi.org.uk>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <0fc77725-c3bc-871e-c640-11b4607b79c7@lucaceresoli.net>
Date: Wed, 27 Jun 2018 11:50:50 +0200
MIME-Version: 1.0
In-Reply-To: <20180627093055.fn6gqpaodzxmhhx3@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 27/06/2018 11:30, Sakari Ailus wrote:
> On Wed, Jun 27, 2018 at 10:13:12AM +0200, Luca Ceresoli wrote:
>> Hi Sakari,
>>
>> On 26/06/2018 14:20, Sakari Ailus wrote:
>>> Hi Luca,
>>>
>>> On Mon, Jun 11, 2018 at 01:35:37PM +0200, Luca Ceresoli wrote:
>>>> Tables of struct reg_8 are used to simplify multi-byte register
>>>> assignment. However filling these snippets with values computed at
>>>> runtime is currently implemented by very similar functions doing the
>>>> needed shift & mask manipulation.
>>>>
>>>> Replace all those functions with a unique helper function to fill
>>>> reg_8 tables in a simple and clean way.
>>>
>>> What's the purpose of writing these registers as multiple I²C writes, when
>>> this can be done as a single write (i.e. the address followed by two or
>>> three octets of data)?
>>
>> Good point. The for loops applying the register values (the lines just
>> after those changed by my patch) defuse the regmap bulk write capability.
>>
>> I guess this could be improved not filling any table, but directly
>> calling regmap_bulk_write(), passing the u16 or u32 register value with
>> proper endianness. No tables, less code. This would replace the present
>> patch with a shorter and more effective one. Is it what you was suggesting?
> 
> Yes, please.

Ok, will do. I think this will cut many lines of code, wow!

Patch 8 is only marginally related to this change, so it can be reviewed
independently except for the few lines in imx274_apply_trimming() where
registers are written.

-- 
Luca
