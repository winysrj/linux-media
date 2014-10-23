Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbaJWNOD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 09:14:03 -0400
Message-ID: <5448FF10.5080204@redhat.com>
Date: Thu, 23 Oct 2014 15:13:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
CC: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com> <5448CB0B.7090606@redhat.com> <5448CCFC.5080606@linux.intel.com> <4925721.xPZdUSiM3q@avalon>
In-Reply-To: <4925721.xPZdUSiM3q@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/23/2014 12:01 PM, Laurent Pinchart wrote:
> On Thursday 23 October 2014 12:40:12 Sakari Ailus wrote:
>> Hi Hans,
>>
>> Hans de Goede wrote:
>>> Maybe we should merge libmediactl into v4l-utils then ? Rather then
>>> v4l-utils growing an external dependency on it. Sakari ?
>>
>> libmediactl is already a part of v4l-utils, but it's under utils rather
>> than lib directory. Cc Laurent.

Ah.

> I'm fine with moving the libraries to lib, but I'm still not 100% sure the ABI 
> can be considered stable.

As long as the ABI is not stable lets keep it in utils and statically link it
into the plugin Jacek is working on for now.

Regards,

Hans
