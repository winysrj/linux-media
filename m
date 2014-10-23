Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaJWJkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 05:40:15 -0400
Message-ID: <5448CCFC.5080606@linux.intel.com>
Date: Thu, 23 Oct 2014 12:40:12 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [v4l-utils RFC 0/2] libmediatext library
References: <1413888015-26649-1-git-send-email-sakari.ailus@linux.intel.com> <54465DDF.5030508@redhat.com> <54477D20.4030207@linux.intel.com> <5448BA21.2040001@redhat.com> <5448C259.5060505@samsung.com> <5448CB0B.7090606@redhat.com>
In-Reply-To: <5448CB0B.7090606@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans de Goede wrote:
> Maybe we should merge libmediactl into v4l-utils then ? Rather then
> v4l-utils growing an external dependency on it. Sakari ?

libmediactl is already a part of v4l-utils, but it's under utils rather 
than lib directory. Cc Laurent.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
