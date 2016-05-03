Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33045 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbcECSeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 14:34:13 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so5330903wme.0
        for <linux-media@vger.kernel.org>; Tue, 03 May 2016 11:34:12 -0700 (PDT)
Subject: Re: [RFC PATCH 06/24] smiapp: Add quirk control support
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-7-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160501104646.GE26360@valkosipuli.retiisi.org.uk>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5728EED5.8010109@gmail.com>
Date: Tue, 3 May 2016 21:32:53 +0300
MIME-Version: 1.0
In-Reply-To: <20160501104646.GE26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On  1.05.2016 13:46, Sakari Ailus wrote:
> On Mon, Apr 25, 2016 at 12:08:06AM +0300, Ivaylo Dimitrov wrote:
>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> Quirk controls can be set up in the init quirk.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Do you need quirk controls for something at the moment? I guess not at least
> with the secondary sensor?
>

Yes, vs6555 doesn't seem to need quirks ATM, I guess that patch comes 
from N9/50 adaptation kernel.

Ivo
