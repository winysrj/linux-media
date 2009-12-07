Return-path: <linux-media-owner@vger.kernel.org>
Received: from thsmsgxrt12p.thalesgroup.com ([192.54.144.135]:50379 "EHLO
	thsmsgxrt12p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758226AbZLGRzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 12:55:39 -0500
Received: from thsmsgirt22p.corp.thales (unknown [10.33.231.6])
	by thsmsgxrt12p.thalesgroup.com (Postfix) with ESMTP id 9E2A641D1E6
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2009 18:55:45 +0100 (CET)
Received: from thsmsgiav13p.corp.thales (10.33.231.33) by thsmsgirt22p.corp.thales (8.5.103)
        id 4B0E9B9B001722B5 for linux-media@vger.kernel.org; Mon, 7 Dec 2009 18:55:45 +0100
Received: from d3smsg01p.services.thales (unknown [10.221.30.27])
	by thsmsgirt12p.corp.thales (Postfix) with ESMTP id 691E0391BBE
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2009 18:55:45 +0100 (CET)
Received: from d3smsg01p.services.thales (10.221.30.17) by d3smsg01p.services.thales (7.3.136)
        id 4AFFF991001B6374 for linux-media@vger.kernel.org; Mon, 7 Dec 2009 18:55:45 +0100
Received: from d3smsg01p.services.thales (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 236214A30054
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2009 18:55:45 +0100 (CET)
Received: from [142.58.148.188] (unknown [142.58.148.188])
	by d3smsg01p.services.thales (Postfix) with ESMTP id C392A4A30030
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2009 18:55:44 +0100 (CET)
Message-ID: <4B1D411F.309@thalesgroup.com>
Date: Mon, 07 Dec 2009 18:53:35 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> In summary,
>
> While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes up to 16 
> bytes
> (since a read loop for 2^16 is not that expensive), the current approach
> won't scale with bigger scancode spaces. So, it is needed expand it
> to work with bigger scancode spaces, used by more recent IR protocols.
>
> I'm afraid that any tricks we may try to go around the current limits to still
> keep using the same ioctl definition will sooner or later cause big headaches.
> The better is to redesign it to allow using different scancode spaces.
>
>
>   
I second you: input layer events from drivers should be augmented with a 
protocol member, allowing us to define new ioctl and new ways to 
efficiently store and manage sparse scancode spaces (tree, hashtable 
....). It will allow us to abstract the scancode value and to use 
variable length scancode depending on the used protocol, and using the 
most appropriate scheme to store the scancode/keycode mapping per protocol.
The today scancode space will be the legacy one, the default if not 
specified "protocol". It will permit to progressively clean up the 
actual acceptable mess in the input layer and finally using real 
scancode -> keycode mappings everywhere if it is cleaner/convenient.

Best regards,
Emmanuel.

