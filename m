Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF4FC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0182084A
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfAVKVd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:21:33 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44836 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfAVKVc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 05:21:32 -0500
Received: from [IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe] ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ltBPg7mGHRO5ZltBSg0eNq; Tue, 22 Jan 2019 11:21:31 +0100
Subject: Re: [v4l-utils PATCH 4/4] v4l2-ctl: Add support for META_OUTPUT
 buffer type
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        yong.zhi@intel.com
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
 <20190114141308.29329-5-sakari.ailus@linux.intel.com>
 <4bb84871-1871-74a0-1093-8e460db46634@xs4all.nl>
 <20190122094750.aak6fl2xskxsio2r@paasikivi.fi.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd6b3447-80a5-43f1-7718-cbe61607e965@xs4all.nl>
Date:   Tue, 22 Jan 2019 11:21:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190122094750.aak6fl2xskxsio2r@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPPHA8NNLD60huX2mZmcJOp8w1ZE6ZqjwyLiHvjJuHCgLmzwvnAhyisK+HKqOUENYtfYFzIaK6+B73oM/ackqGMDUUj1NluRp7oqhgOqzn48OvbFKh/z
 z7d5VT+FB/eKHD8cDfVn+7KkTa5SAekFVuQ/t7YUI06o6fhM9WYz67mUEzG4q4PNJpOaKOAI+L0SMPeBk82OIPKlL32fe3rHdvn7Wd6lvn+1vf37DTKBjsH7
 HbarBZxp6YjI6zywJBuat3kn8WblKNIq/tb7M61rPq3VpMmRHLWfx2Xektos9jCjC0xw9xffec3veSmnWmDrKZ0Wg1Tkb4x5hX8BzLwkHdpjhImSGP0iCwxJ
 zfmjEDzF+gJBZh0zGiyO18j6pf/BGhWWGe+mzCdP9d1FfLxWvNk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/22/19 10:47, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Jan 22, 2019 at 09:19:42AM +0100, Hans Verkuil wrote:
>> Hi Sakari,
>>
>> Can you check if this patch is needed at all? The latest v4l2-ctl should work
>> for both meta capture and output, i.e. all meta options (v4l2-ctl --help-meta)
>> just look up the buffer type of the video device and use that to list/set/get/try
>> the formats.
> 
> That'd be one option. I guess we don't have that elsewhere, do we? In
> practice it could work, but it'd prevent having the two queue types in the
> same video node. It seems an improbable combination though.
> 
> I'd prefer keeping the options separate to maintain v4l2-ctl's ability to
> access all aspects of the API, even if unlikely.

Well, you can add -out options for consistency, but the code remains the
same :-)

> But the help option should probably be unified, like it is for SDR.
> 

Definitely.

Regards,

	Hans
