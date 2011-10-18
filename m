Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61790 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1JRRwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 13:52:09 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id p9IHq8iH023061
	for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 10:52:08 -0700
Received: from pzk1 (pzk1.prod.google.com [10.243.19.129])
	by hpaq7.eem.corp.google.com with ESMTP id p9IHjkC7004785
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 10:52:06 -0700
Received: by pzk1 with SMTP id 1so2621032pzk.9
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 10:52:06 -0700 (PDT)
Date: Tue, 18 Oct 2011 10:52:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] videodev: fix a NULL pointer dereference in
 v4l2_device_release()
In-Reply-To: <20111018103525.10399d9d2f51a53fd0d6eb20@studenti.unina.it>
Message-ID: <alpine.DEB.2.00.1110181051380.5269@chino.kir.corp.google.com>
References: <1318456766-4165-1-git-send-email-ospite@studenti.unina.it> <20111018103525.10399d9d2f51a53fd0d6eb20@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011, Antonio Ospite wrote:

> > can anyone reproduce this?
> >
> 
> Ping.
> 
> David, does the change below fix it for you, I sent the patch
> last week.
> 

I never had the problem.
