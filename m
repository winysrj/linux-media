Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12]:60127 "EHLO
	amy.cooptel.qc.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754448Ab0BINoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 08:44:09 -0500
Message-ID: <4B7166A5.8050402@cooptel.qc.ca>
Date: Tue, 09 Feb 2010 08:44:05 -0500
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
 (DVB-S) and USB HVR Hauppauge 950q
References: <4B70E7DB.7060101@cooptel.qc.ca> <829197381002082118k346437b3y4dc2eb76d017f24f@mail.gmail.com>
In-Reply-To: <829197381002082118k346437b3y4dc2eb76d017f24f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

I was previously running kernel vmlinux-2.6.29.5.  I notice there was a major
reorganization of some of the media structure between 2.6.29 and 2.6.32.
Can you tell me at wich kernel version the change occured so I can start from there.

Richard

Devin Heitmueller wrote:
> On Mon, Feb 8, 2010 at 11:43 PM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
>> Hi,
>>
>> I got some driver crashes after upgrading to kernel 2.6.32.7.  It seems that
>> activating either TBS8920 (DVB-S) and HVR950Q (ATSC) after the other one has
>> run (and is no longer in use by an application) triggers a driver crash.
> 
> Hello Richard,
> 
> Have you tried any other kernel version?  For example, do you know
> that it works properly in 2.6.32.6?
> 
> Can you bisect and see when the problem was introduced?
> 
> Devin
> 
