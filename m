Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaFKGep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 02:34:45 -0400
Message-ID: <5397F87E.4020107@linux.intel.com>
Date: Wed, 11 Jun 2014 09:34:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu
 item definitions
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com> <CA+V-a8vUrB3nUxfiZgjkjpQZh-r8z-mavPesJ4-fPhC=AaExKw@mail.gmail.com>
In-Reply-To: <CA+V-a8vUrB3nUxfiZgjkjpQZh-r8z-mavPesJ4-fPhC=AaExKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the review! :-)

Prabhakar Lad wrote:
> Hi Sakari,
>
> On Thu, May 29, 2014 at 3:40 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
>> Add numeric definitions for menu items used in the smiapp driver's test
>> pattern menu.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++
>
> Don't you need to add an entry in Kbuild file for this ?

Good poing. I'll send v3.1 for this one as well.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
