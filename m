Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:55165 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0C3PVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 11:21:41 -0400
Received: by fxm23 with SMTP id 23so376888fxm.21
        for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 08:21:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <tkrat.7f9b79c0eafb6d4f@sensoray.com>
References: <tkrat.7f9b79c0eafb6d4f@sensoray.com>
Date: Tue, 30 Mar 2010 11:21:39 -0400
Message-ID: <30353c3d1003300821n4b38f974w57ab6858252aa50f@mail.gmail.com>
Subject: Re: [PATCH] s2255drv: cleanup of driver disconnect code
From: David Ellingsworth <david@identd.dyndns.org>
To: "Dean A." <dean@sensoray.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, isely@pobox.com,
	andre.goddard@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch looks good, but there was one other thing that caught my eye.

In s2255_probe_v4l, video_device_alloc is called for each video
device, which is nothing more than a call to kzalloc, but the result
of the call is never verified.

Given that this driver has a fixed number of video device nodes, the
array of video_device structs could be allocated within the s2255_dev
struct. This would remove the extra calls to video_device_alloc,
video_device_release, and the additional error checks that should have
been there. If you'd prefer to keep the array of video_device structs
independent of the s2255_dev struct, an alternative would be to
dynamically allocate the entire array at once using kcalloc and store
only the pointer to the array in the s2255_dev struct. In my opinion,
either of these methods would be better than calling
video_device_alloc for each video device that needs to be registered.

Regards,

David Ellingsworth
