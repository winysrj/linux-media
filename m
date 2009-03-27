Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2125 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZC0H2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 03:28:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] Allow the user to restrict the RC5 address
Date: Fri, 27 Mar 2009 08:28:15 +0100
Cc: "Udo A. Steinberg" <udo@hypervisor.org>,
	Steven Toth <stoth@linuxtv.org>,
	Darron Broad <darron@kewl.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20090326033453.7d90236d@laptop.hypervisor.org> <49CBB11E.2030604@linuxtv.org> <20090326194553.3903ae61@laptop.hypervisor.org>
In-Reply-To: <20090326194553.3903ae61@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270828.15911.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 March 2009 19:45:53 Udo A. Steinberg wrote:
> On Thu, 26 Mar 2009 12:45:18 -0400 Steven Toth (ST) wrote:
>
> ST> I too tend to have multiple remotes, I don't think it's that unusual
> for ST> long standing Hauppauge customers to have many boards with many
> types of ST> remotes.
> ST>
> ST> > It might be better to have an option to explicitly allow old
> Hauppauge ST> > remotes that send 0x00.
> ST> >
> ST> I could live with this. It relegates older remotes but those remotes
> ST> are no longer made. This feels like a good compromise.
>
> How about changing the parameter such that it is a filter mask? The
> default value of 0x0 would accept all remotes. For non-zero values, each
> bit set in the parameter would filter the device address corresponding to
> that bit, e.g. 0x1 would filter address 0x0, 0x80000000 would filter
> address 0x1f, etc.

Seems way to complicated to me. Remember that end users have no idea about 
the device addresses, so it should be a simple to understand module option. 
So I'd just go with Steve's preference.

Regards,

	Hans

>
> Cheers,
>
> 	- Udo



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
