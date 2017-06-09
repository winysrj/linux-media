Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46062 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdFIKDx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 06:03:53 -0400
Subject: Re: [PATCH v4] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1496829127-28375-1-git-send-email-kbingham@kernel.org>
 <20170608150022.5f696e58@vento.lan>
 <20170608193210.GJ1019@valkosipuli.retiisi.org.uk>
 <20170608171043.73dd28aa@vento.lan>
Cc: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <3f9a0b3e-9da6-d2a3-7b3b-793ed0d1872d@ideasonboard.com>
Date: Fri, 9 Jun 2017 11:03:47 +0100
MIME-Version: 1.0
In-Reply-To: <20170608171043.73dd28aa@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Mauro,

On 08/06/17 21:10, Mauro Carvalho Chehab wrote:
> Em Thu, 8 Jun 2017 22:32:10 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> Hi Mauro,
>>
>> On Thu, Jun 08, 2017 at 03:00:22PM -0300, Mauro Carvalho Chehab wrote:
>>> Em Wed,  7 Jun 2017 10:52:07 +0100
>>> Kieran Bingham <kbingham@kernel.org> escreveu:
>>>   
>>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>
>>>> Return NULL, if a null entity is parsed for it's v4l2_subdev
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>  
>>>
>>> Could you please improve this patch description?
>>>
>>> I'm unsure if this is a bug fix, or some sort of feature...
>>>
>>> On what situations would a null entity be passed to this function? 

Sorry for not being clear enough there ...

>>
>> I actually proposed this patch. This change is simply for convenience ---
>> the caller doesn't need to make sure the subdev is non-NULL, possibly
>> obtained from e.g. media_entity_remote_pad() which returns NULL all links to
>> the pad are disabled. This is a recurring pattern, and making this change
>> avoids an additional check.
>>
>> Having something along these lines in the patch description wouldn't hurt.

Yes, the above looks good ...

> Patch added, with a description based on the above.

And thank you :)

Regards
--
Kieran
