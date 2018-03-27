Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34339 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751068AbeC0PAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:00:18 -0400
Subject: Re: [RFC v2 00/10] Preparing the request API
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: acourbot@chromium.org, Tomasz Figa <tfiga@chromium.org>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
 <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
 <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
 <f11c24e1-599d-3248-008c-4730569cfa10@xs4all.nl>
Message-ID: <689b6b77-2d7c-0673-84b1-41c7bfaeeda3@xs4all.nl>
Date: Tue, 27 Mar 2018 17:00:12 +0200
MIME-Version: 1.0
In-Reply-To: <f11c24e1-599d-3248-008c-4730569cfa10@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Status update:

Current work-in-progress tree:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv8

v4l2-compliance test code:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

It is now working for me with v4l2-compliance and vim2m and vivid.

All requests and request objects are correctly freed after doing all
the v4l2-compliance tests.

It's a fairly decent test coverage, but I'm sure there are some corner
cases that can be added.

I've frozen my reqv8 branch so that can be used as a starting point for
codec drivers.

I've started a reqv9 which will be the cleaned-up version of reqv8.
My hope is that I can finish that tomorrow and post the patch series
to the ML at the end of the day.

Regards,

	Hans
