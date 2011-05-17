Return-path: <mchehab@pedra>
Received: from rouge.crans.org ([138.231.136.3]:52773 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab1EQPwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 11:52:06 -0400
Message-ID: <4DD29848.6030901@braice.net>
Date: Tue, 17 May 2011 17:46:16 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: Tomer Barletz <barletz@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [libdvben50221] [PATCH] Assign same resource_id in open_session_response
 when "resource non-existent"
References: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>
In-Reply-To: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 18/01/2011 15:42, Tomer Barletz wrote:
> Attached a patch for a bug in the lookup_callback function, were in
> case of a non-existent resource, the connected_resource_id is not
> initialized and then used in the open_session_response call of the
> session layer.
> 

Hello

Can you explain what kind of bug it fixes ?

Thanks
