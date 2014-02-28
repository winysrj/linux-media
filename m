Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.114]:33960 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaB1JWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 04:22:21 -0500
Message-ID: <53105135.9030909@imgtec.com>
Date: Fri, 28 Feb 2014 09:04:53 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 06/15] dt: binding: add binding for ImgTec IR block
References: <CAL_JsqLL6MbwajCUAm+NJk=ofL5OHq8b0zwO3LFb-TKY6UtVMQ@mail.gmail.com> <1391788155-29191-1-git-send-email-james.hogan@imgtec.com> <2514111.qYAaEZbJqk@radagast> <CAL_JsqJpbUzEUpUxtFe4JeZ=EtCfaQHsyPt3TqH8AJkGNRnTvw@mail.gmail.com>
In-Reply-To: <CAL_JsqJpbUzEUpUxtFe4JeZ=EtCfaQHsyPt3TqH8AJkGNRnTvw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/02/14 01:28, Rob Herring wrote:
> On Thu, Feb 27, 2014 at 4:52 PM, James Hogan <james.hogan@imgtec.com> wrote:
>>> v3:
>>> - Rename compatible string to "img,ir-rev1" (Rob Herring).
>>> - Specify ordering of clocks explicitly (Rob Herring).
>>
>> I'd appreciate if somebody could give this another glance after the two
>> changes listed above and Ack it (I'll probably be posting a v4 patchset
>> tomorrow).
> 
> Looks fine.
> 
> Acked-by: Rob Herring <robh@kernel.org>

Thanks Rob!

Cheers
James
