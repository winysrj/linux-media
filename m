Return-path: <mchehab@pedra>
Received: from asmtpout021.mac.com ([17.148.16.96]:59757 "EHLO
	asmtpout021.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1FFKU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 06:20:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
Received: from [192.168.129.14] ([125.178.234.180])
 by asmtp021.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LMD008VC3A2OB60@asmtp021.mac.com>
 for linux-media@vger.kernel.org; Mon, 06 Jun 2011 02:20:36 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] m5mols: remove union in the m5mols_get_version(),
 and VERSION_SIZE
From: Kim HeungJun <riverful.kim@me.com>
In-reply-to: <20110605121129.GE6073@valkosipuli.localdomain>
Date: Mon, 06 Jun 2011 18:20:25 +0900
Cc: Kim HeungJun <riverful.kim@me.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Content-transfer-encoding: 8BIT
Message-id: <5B70BEF2-0968-4591-8B39-CA95620CA329@me.com>
References: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
 <1306827362-4064-4-git-send-email-riverful.kim@samsung.com>
 <20110605120347.GD6073@valkosipuli.localdomain>
 <20110605121129.GE6073@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


2011. 6. 5., 오후 9:11, Sakari Ailus 작성:

> On Sun, Jun 05, 2011 at 03:03:47PM +0300, Sakari Ailus wrote:
> [clip]
>>> -	/* store version information swapped for being readable */
>>> -	info->ver	= version.ver;
>>> 	info->ver.fw	= be16_to_cpu(info->ver.fw);
>>> 	info->ver.hw	= be16_to_cpu(info->ver.hw);
>>> 	info->ver.param	= be16_to_cpu(info->ver.param);
>> 
>> As you have a local variable ver pointing to info->ver, you should also use
>> it here.
> 
> With this change,
Ok, I missed that. I'll fix this and resend another version.

Thanks!


> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> -- 
> Sakari Ailus
> sakari dot ailus at iki dot fi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

