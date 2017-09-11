Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:38423 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdIKVLo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 17:11:44 -0400
Subject: Re: [PATCH v9 18/24] as3645a: Switch to fwnode property API
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-14-sakari.ailus@linux.intel.com>
 <f6c79aff-dcc7-ee7d-e224-1f9bc6af1fee@gmail.com>
 <20170909213658.6hqbsn66q4xc2sex@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <eefe9707-0486-8440-1074-abb7c317dbe3@gmail.com>
Date: Mon, 11 Sep 2017 23:10:49 +0200
MIME-Version: 1.0
In-Reply-To: <20170909213658.6hqbsn66q4xc2sex@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/09/2017 11:36 PM, Sakari Ailus wrote:
> Hi Jacek,
> 
> On Sat, Sep 09, 2017 at 09:06:41PM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> I've come across this patch only by a chance. I believe that merging
>> leds-as3645a.c patches via media tree is not going to be a persistent
>> pattern. At least we haven't agreed on that, and in any case I should
>> have a possibility to give my ack for this patch.
> 
> Correct. The reason the previous patches went through linux-media was
> because these patches dependend on other patches only in linux-media at the
> time. This is no longer the case (the three as3645a patches I'd like to get
> in as fixes are another matter but let's discuss that separately).
> 
>>
>> Would you mind also adding linux-leds list on cc when touching areas
>> related to LED/flash devices?
> 
> I added this patch to this version of the set and missed cc'ing it to
> linux-leds. I think I'll send it there separately once the 17th patch (ACPI
> support) has been reviewed. The two are loosely related to the rest of the
> patches in the set but there's no hard dependency.

Right, they are loosely related, but cross-posting anything having "LED"
in its contents to linux-leds list would be understandable if not
desirable :-) Just to keep LED people in sync.

-- 
Best regards,
Jacek Anaszewski
