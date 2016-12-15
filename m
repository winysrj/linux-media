Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38806
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755860AbcLOTSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 14:18:01 -0500
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource
 management
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
 <3081773.GUJA4mrXhH@avalon> <58528255.2070708@linux.intel.com>
 <34468031.gaR5u7AJSf@avalon>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, mchehab@osg.samsung.com,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <96a9c7f4-2a9b-2d21-0dd2-baa769fdf605@osg.samsung.com>
Date: Thu, 15 Dec 2016 12:17:58 -0700
MIME-Version: 1.0
In-Reply-To: <34468031.gaR5u7AJSf@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Skarai,

On 12/15/2016 04:57 AM, Laurent Pinchart wrote:
> On Thursday 15 Dec 2016 13:45:25 Sakari Ailus wrote:
>> Hi Laurent,
>>
>> On 12/15/16 13:42, Laurent Pinchart wrote:
>>> You can split that part out. The devm_* removal is independent and could
>>> be moved to the beginning of the series.
>>
>> Where do you release the memory in that case? In driver's remove(), i.e.
>> this patch would simply move that code to isp_remove()?
> 
> Yes, the kfree() calls would be in isp_remove(). The patch will then be 
> faithful to its $SUBJECT, and moving to a release() handler should be done in 
> a separate patch.
> 

I have a patch that does that for you. I was playing with devm removal from
omap3. You are welcome to just use it. This also includes regulator puts in
proper places. I also included a patch that removes extra media_entity_cleanup()

I will send those in a bit

thanks,
-- Shuah



