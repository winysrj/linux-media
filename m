Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34082 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbeHUAGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 20:06:39 -0400
Received: by mail-qt0-f193.google.com with SMTP id m13-v6so17831023qth.1
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 13:49:31 -0700 (PDT)
Message-ID: <f0af3753f5f92b4444674c0d0c9aa88118cc6245.camel@redhat.com>
Subject: Re: [PATCH (repost) 3/5] drm_dp_mst_topology: fix broken
 drm_dp_sideband_parse_remote_dpcd_read()
From: Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date: Mon, 20 Aug 2018 16:49:29 -0400
In-Reply-To: <9c789fd1-94fa-af2f-237d-1eb95903b701@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
         <20180817141122.9541-4-hverkuil@xs4all.nl>
         <85407132acc51cf749f8087128d4ebe326db6af2.camel@redhat.com>
         <9c789fd1-94fa-af2f-237d-1eb95903b701@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-08-20 at 22:43 +0200, Hans Verkuil wrote:
> On 08/20/2018 08:59 PM, Lyude Paul wrote:
> > Reviewed-by: Lyude Paul <lyude@redhat.com>
> > 
> > We really need to add support for using this into the MST helpers. A good
> > way to
> > test this would probably be to hook up an aux device to the DP AUX adapters
> > we
> > create for each MST topology
> 
> If you are interested, I have code for that in my MST test branch:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cec-nv-amd-mst
> 
> It's the "drm_dp_mst_topology: use correct AUX channel" patch.
> 
> I don't have plans to post this patch since CEC for MST isn't working
> (still trying to figure out why not), but you are free to pick it up
> if you want.
Maybe someday but don't count on it yet! I've got a lot of stuff on my plate atm
:)

> 
> Regards,
> 
> 	Hans
> 
> > 
> > On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > When parsing the reply of a DP_REMOTE_DPCD_READ DPCD command the
> > > result is wrong due to a missing idx increment.
> > > 
> > > This was never noticed since DP_REMOTE_DPCD_READ is currently not
> > > used, but if you enable it, then it is all wrong.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > >  drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > index 7780567aa669..5ff1d79b86c4 100644
> > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > @@ -439,6 +439,7 @@ static bool
> > > drm_dp_sideband_parse_remote_dpcd_read(struct
> > > drm_dp_sideband_msg_rx
> > >  	if (idx > raw->curlen)
> > >  		goto fail_len;
> > >  	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
> > > +	idx++;
> > >  	if (idx > raw->curlen)
> > >  		goto fail_len;
> > >  
> 
> 
