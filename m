Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59919 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaCESMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 13:12:16 -0500
Received: by mail-qc0-f180.google.com with SMTP id x3so1608050qcv.11
        for <linux-media@vger.kernel.org>; Wed, 05 Mar 2014 10:12:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
Date: Wed, 5 Mar 2014 20:12:15 +0200
Message-ID: <CAKv9HNZ7CG85J0B_xqO_QUH+FWafXZ8oB11V92P6+tOjARLhNw@mail.gmail.com>
Subject: Re: [PATCH 0/5] rc: scancode filtering improvements
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sean Young <sean@mess.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 March 2014 01:17, James Hogan <james.hogan@imgtec.com> wrote:
> These patches make some improvements relating to the recently added RC
> scancode filtering interface:
> - Patch 1 adds generic scancode filtering. This allows filtering to also
>   work for raw rc drivers and scancode drivers without filtering
>   capabilities.
> - Patches 2-4 future proof the sysfs API to allow a different wakeup
>   filter protocol to be set than the current protocol. A new
>   wakeup_protocols sysfs file is added which behaves similarly to the
>   protocols sysfs file but applies only to wakeup filters.
> - Finally patch 5 improves the driver interface so that changing either
>   the normal or wakeup protocol automatically causes the corresponding
>   filter to be refreshed to the driver, or failing that cleared. It also
>   ensures that the filter is turned off (and for wakeup that means
>   wakeup is disabled) if the protocol is set to none. This avoids the
>   driver having to maintain the filters, or even need a
>   change_wakeup_protocol() callback if there is only one wakeup protocol
>   allowed at a time.
>
> The patch "rc-main: store_filter: pass errors to userland" should
> probably be applied first.
>
> An updated img-ir v4 patchset which depends on this one will follow
> soon.
>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: "Bruno Prémont" <bonbons@linux-vserver.org>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Sean Young <sean@mess.org>
> Cc: "David Härdeman" <david@hardeman.nu>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "Antti Seppälä" <a.seppala@gmail.com>
>

After reviewing the series and porting my nuvoton changes to it I
haven't noticed any errors worth mentioning.
In fact I think this series is very well written and should be merged.

James, I hope you also have the time to submit the ir encoder series
for inclusion. :)

Reviewed-by: Antti Seppälä <a.seppala@gmail.com>
