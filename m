Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49988 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab2ENPsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 11:48:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=windows-1252
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4000BN8RWVA680@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 May 2012 16:48:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4000JYBRWH8T@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 May 2012 16:48:17 +0100 (BST)
Date: Mon, 14 May 2012 17:48:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v5 18/35] v4l: Allow changing control handler lock
In-reply-to: <4FB12458.80809@samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Message-id: <4FB12942.3020907@samsung.com>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-18-git-send-email-sakari.ailus@iki.fi>
 <4FB12458.80809@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2012 05:27 PM, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 03/06/2012 05:32 PM, Sakari Ailus wrote:
>> Allow choosing the lock used by the control handler. This may be handy
>> sometimes when a driver providing multiple subdevs does not want to use
>> several locks to serialise its functions.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/adp1653.c    |    8 +++---
>>  drivers/media/video/v4l2-ctrls.c |   39 +++++++++++++++++++------------------
>>  drivers/media/video/vivi.c       |    4 +-
>>  include/media/v4l2-ctrls.h       |    9 +++++--
>>  4 files changed, 32 insertions(+), 28 deletions(-)
> ...
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index 533315b..71abac0 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -168,7 +168,9 @@ struct v4l2_ctrl_ref {
>>  /** struct v4l2_ctrl_handler - The control handler keeps track of all the
>>    * controls: both the controls owned by the handler and those inherited
>>    * from other handlers.
>> +  * @_lock:	Default for "lock".
>>    * @lock:	Lock to control access to this handler and its controls.
>> +  *		May be replaced by the user right after init.
>>    * @ctrls:	The list of controls owned by this handler.
>>    * @ctrl_refs:	The list of control references.
>>    * @cached:	The last found control reference. It is common that the same
>> @@ -179,7 +181,8 @@ struct v4l2_ctrl_ref {
>>    * @error:	The error code of the first failed control addition.
>>    */
>>  struct v4l2_ctrl_handler {
>> -	struct mutex lock;
>> +	struct mutex _lock;
>> +	struct mutex *lock;
> 
> I think we have an issue here. All drivers that reference ctrl_handler.lock
> directly need to be updated, since the 'lock' member of struct v4l2_ctrl_handler
> is now a pointer. So instead 
> 
> mutex_lock(&ctrl_handler.lock);
> 
> they should now do
> 
> mutex_lock(ctrl_handler.lock);
> 
> Or am I missing something ?
> 
> For example, I'm getting following error:
> 
> drivers/media/video/s5p-fimc/fimc-core.c: In function �fimc_ctrls_activate�:
> drivers/media/video/s5p-fimc/fimc-core.c:678: warning: passing argument 1 of �mutex_lock� from incompatible pointer type
> include/linux/mutex.h:152: note: expected �struct mutex *� but argument is of type �struct mutex **�
> drivers/media/video/s5p-fimc/fimc-core.c:697: warning: passing argument 1 of �mutex_unlock� from incompatible pointer type
> include/linux/mutex.h:169: note: expected �struct mutex *� but argument is of type �struct mutex **�
> 
> AFAICT only vivi and s5p-fimc drivers use the control handler lock 
> directly, so I can prepare a patch updating those drivers.

OK, vivi and adp1653 are already modified in this patch, so s5p-fimc
seems the only one left. I'll fix that.

Regards,
Sylwester
