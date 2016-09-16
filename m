Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34846 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbcIPHZa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 03:25:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 3BA4D2017A
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 10:25:28 +0300 (EEST)
Subject: Re: [git:v4l-utils/master] media-ctl: Fix a compilation bug
 introduced by changeset 7a21d66983f7
To: linux-media@vger.kernel.org
References: <E1bknKY-0002n9-Gp@www.linuxtv.org>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57DB9E68.4000701@linux.intel.com>
Date: Fri, 16 Sep 2016 10:25:28 +0300
MIME-Version: 1.0
In-Reply-To: <E1bknKY-0002n9-Gp@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/16 10:11, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/cgit.cgi/v4l-utils.git tree:
> 
> Subject: media-ctl: Fix a compilation bug introduced by changeset 7a21d66983f7
> Author:  Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:    Fri Sep 16 04:11:06 2016 -0300
> 
> options.c:56:9: warning: missing terminating " character
> options.c:56:9: error: missing terminating " character
> options.c:57:71: error: expected ')' before ';' token
> options.c:57:2: warning: passing argument 1 of 'printf' makes pointer from integer without a cast [-Wint-conversion]
> options.c:94:1: error: expected ';' before '}' token
> options.c:42:15: warning: unused variable 'i' [-Wunused-variable]
> 
> Clearly, nobody tested this patch before merging it.

It was tested but not with the latest help text I got from Laurent.

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
