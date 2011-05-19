Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34566 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab1ESVB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 17:01:26 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Andreas Oberritter'" <obi@linuxtv.org>,
	"'Tomer Barletz'" <barletz@gmail.com>
Cc: "'Brice DUBOST'" <braice@braice.net>, <linux-media@vger.kernel.org>
References: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>	<4DD29848.6030901@braice.net> <BANLkTin6astzASvU6VfDwD2XCRuZToq+RQ@mail.gmail.com> <4DD513F5.8060602@linuxtv.org>
In-Reply-To: <4DD513F5.8060602@linuxtv.org>
Subject: RE: [libdvben50221] [PATCH] Assign same resource_id in open_session_response when "resource non-existent"
Date: Thu, 19 May 2011 23:01:30 +0200
Message-ID: <005501cc1667$ee99a130$cbcce390$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Andreas Oberritter
> Sent: jeudi 19 mai 2011 14:58
> To: Tomer Barletz
> Cc: Brice DUBOST; linux-media@vger.kernel.org
> Subject: Re: [libdvben50221] [PATCH] Assign same resource_id in
> open_session_response when "resource non-existent"
> 
> On 05/18/2011 09:16 PM, Tomer Barletz wrote:
> > On Tue, May 17, 2011 at 8:46 AM, Brice DUBOST <braice@braice.net>
> wrote:
> >> On 18/01/2011 15:42, Tomer Barletz wrote:
> >>> Attached a patch for a bug in the lookup_callback function, were in
> >>> case of a non-existent resource, the connected_resource_id is not
> >>> initialized and then used in the open_session_response call of the
> >>> session layer.
> >>>
> >>
> >> Hello
> >>
> >> Can you explain what kind of bug it fixes ?
> >>
> >> Thanks
> >>
> >
> > The standard states that in case the module can't provide the
> > requested resource , it should reply with the same resource id - this
> > is the only line that was added.
> > Also, since the caller to this function might use the variable
> > returned, this variable must be initialized.
> > The attached patch solves both bugs.
> 
> Can you please resend the patch inline with a proper signed-off-by line,
> in order to get it tracked by patchwork.kernel.org?
> 

Yes, of course, but I don't find information that can help me to provide the
correct format.
Is-there a documentation somewhere that explains how patches must be
formatted to be correctly tracked?

> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

