Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZJDKFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 06:05:21 -0400
Message-ID: <4AC8745C.1010207@redhat.com>
Date: Sun, 04 Oct 2009 12:09:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Programming sensor through firmware files bc of NDA
References: <A24693684029E5489D1D202277BE89444C9C9C11@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444C9C9C11@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/02/2009 03:55 PM, Aguirre Rodriguez, Sergio Alberto wrote:
> Hi all,
>
> I'm currently interested in knowing what is the stand on having a
> v4l2_subdev driver that uses some kind of binary for programming
> registers in a image sensor driver.
>
> NOTE: I must confess I currently don't know how to do it
> (Any pointers/samples for doing it on a proper way?)
>
> The only reason for doing this is to avoid potential violation of
> NDA with sensor manufacturer by exposing all register details.
>
> Please comment.
>

Only speaking for myself, IANAL, but AFAIK the stand on that is that it
is not acceptable. We do not want any blobs to be loaded into the kernel,
also note that AFAIK most v4l subsystem symbols are exported GPL_ONLY, iow
they are intended only for use by GPL licenses kernel module, so not by blobs.

Regards,

Hans
