Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49912 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866AbZGQQKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 12:10:16 -0400
Date: Fri, 17 Jul 2009 18:10:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firedtv: refine AVC debugging
To: Henrik Kurelid <henke@kurelid.se>
cc: linux-media@vger.kernel.org
In-Reply-To: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
Message-ID: <tkrat.32ec89ba5c818f88@s5r6.in-berlin.de>
References: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 Jul, Henrik Kurelid wrote:
[I wrote]
>> Shouldn't the three return statements in debug_fcp_opcode_flag_set be
>> 'return 0' rather than one?
> I gave this some thought when I implemented it. These are "should not
> happend"-situations where the drivers or hardware sends unknown/
> unimplemented commands. Rather than making sure that they are never
> seen in the logs I wanted them to always be logged (as long as some
> debug logging is turned on) since they indicate driver/hw problems.

Ah, that's why.  Could be documented:

static int debug_fcp_opcode_flag_set(unsigned int opcode,
				     const u8 *data, int length)
{
	switch (opcode) {
	case AVC_OPCODE_VENDOR:			break;
	case AVC_OPCODE_READ_DESCRIPTOR:	return avc_debug & AVC_DEBUG_READ_DESCRIPTOR;
	case AVC_OPCODE_DSIT:			return avc_debug & AVC_DEBUG_DSIT;
	case AVC_OPCODE_DSD:			return avc_debug & AVC_DEBUG_DSD;
	default:				goto unknown_opcode;
	}

	if (length < 7 ||
	    data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
	    data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
	    data[5] != SFE_VENDOR_DE_COMPANYID_2)
		goto unknown_opcode;

	switch (data[6]) {
	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL;
	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return avc_debug & AVC_DEBUG_LNB_CONTROL;
	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return avc_debug & AVC_DEBUG_TUNE_QPSK;
	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return avc_debug & AVC_DEBUG_TUNE_QPSK2;
	case SFE_VENDOR_OPCODE_HOST2CA:			return avc_debug & AVC_DEBUG_HOST2CA;
	case SFE_VENDOR_OPCODE_CA2HOST:			return avc_debug & AVC_DEBUG_CA2HOST;
	}

unknown_opcode:  /* should never happen, log it */
	return 1;
}


By the way, from here it looks as if your MUA converted tabs to spaces.
In your other patch too.
-- 
Stefan Richter
-=====-==--= -=== =---=
http://arcgraph.de/sr/

