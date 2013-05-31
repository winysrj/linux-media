Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56340 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999Ab3EaBFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 21:05:46 -0400
Message-ID: <51A7F8A1.7020709@iki.fi>
Date: Fri, 31 May 2013 04:10:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <1368692074-483-3-git-send-email-a.hajda@samsung.com> <20130516223451.GA2077@valkosipuli.retiisi.org.uk> <519A3219.9040809@samsung.com>
In-Reply-To: <519A3219.9040809@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Andrzej Hajda wrote:
>> I have to say I don't think it's neither meaningful to acquire that mutex in
>> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
>> anyway: reference counting would be needed to prevent bad things from
>> happening, in case the drivers wouldn't take care of that.
> I do not understand what do you mean exactly. Could you please explain
> it more?
> What do you want to reference count?

I don't want to, but simply acquiring a lock which is a part of an 
object being destroyed makes no sense. If something else has a reference 
to the object you're screwed anyway; acquiring the lock does not help.

-- 
Sakari Ailus
sakari.ailus@iki.fi
