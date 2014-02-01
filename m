Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49046 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299AbaBAJDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 04:03:36 -0500
Message-ID: <52ECB922.7050302@iki.fi>
Date: Sat, 01 Feb 2014 11:06:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use
 it
References: <201308281419.52009.hverkuil@xs4all.nl> <344618801.kmLM0jZvMY@avalon> <52A9ADF6.2090900@xs4all.nl> <18082456.iNCn4Qe0lB@avalon> <52EBC534.8080903@xs4all.nl> <20140131164233.GB15383@valkosipuli.retiisi.org.uk> <52EBDB8B.80202@xs4all.nl>
In-Reply-To: <52EBDB8B.80202@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> Hi Sakari,
> 
> On 01/31/2014 05:42 PM, Sakari Ailus wrote:
>> Hi Hans and Laurent,
>>
>> On Fri, Jan 31, 2014 at 04:45:56PM +0100, Hans Verkuil wrote:
>>> How about defining a capability for use with ENUMINPUT/OUTPUT? I agree that this
>>> won't change between buffers, but it is a property of a specific input or output.
>>
>> Over 80 characters per line. :-P
> 
> Stupid thunderbird doesn't show the column, and I can't enable
> automatic word-wrap because that plays hell with patches. Solutions
> welcome!

Does it? I've used Thunderbird (well, mostly just tried) but I've
thought it behaves the same way as Seamonkey: wrapping only applies to
newly written lines. My $EDITOR does the same when I use Mutt.

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
