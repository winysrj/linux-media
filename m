Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760283Ab0J2DPb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:15:31 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T3FVBv031165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:15:31 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9T3FVei032092
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:15:31 -0400
Date: Thu, 28 Oct 2010 23:15:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029031530.GH17238@redhat.com>
References: <20101029031131.GE17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029031131.GE17238@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 28, 2010 at 11:11:31PM -0400, Jarod Wilson wrote:
> I've got one of those tiny little 6-button Apple remotes here, now it can
> be decoded in-kernel (tested w/an mceusb transceiver).

Oh yeah, RFC, because I'm not sure if we should have a more generic "skip
the checksum check" support -- I seem to recall discussion about it in the
not so recent past. And a decoder hack for one specific remote is just
kinda ugly...

-- 
Jarod Wilson
jarod@redhat.com

