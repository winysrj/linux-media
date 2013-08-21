Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56420 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 17:39:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 08/10] DocBook: document new v4l motion detection event.
Date: Wed, 21 Aug 2013 23:41 +0200
Message-ID: <7288776.lXyIOr0qYX@avalon>
In-Reply-To: <1376305113-17128-9-git-send-email-hverkuil@xs4all.nl>
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl> <1376305113-17128-9-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 12 August 2013 12:58:31 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 40 +++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  9 +++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml index 89891ad..23ee1e3
> 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> @@ -94,6 +94,12 @@
>  	  </row>
>  	  <row>
>  	    <entry></entry>
> +	    <entry>&v4l2-event-motion-det;</entry>
> +            <entry><structfield>motion_det</structfield></entry>
> +	    <entry>Event data for event V4L2_EVENT_MOTION_DET.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
>  	    <entry>__u8</entry>
>              <entry><structfield>data</structfield>[64]</entry>
>  	    <entry>Event data. Defined by the event type. The union
> @@ -242,6 +248,40 @@
>        </tgroup>
>      </table>
> 
> +    <table frame="none" pgwide="1" id="v4l2-event-motion-det">
> +      <title>struct <structname>v4l2_event_motion_det</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +	    <entry>
> +	      Currently only one flag is available: if
> <constant>V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ</constant> +	      is set, then
> the <structfield>frame_sequence</structfield> field is valid, +	     
> otherwise that field should be ignored.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>frame_sequence</structfield></entry>
> +	    <entry>
> +	      The sequence number of the frame being received. Only valid if the
> +	      <constant>V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ</constant> flag was set.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>region_mask</structfield></entry>
> +	    <entry>
> +	      The bitmask of the regions that reported motion. There is at least
> one
> +	      region. If this field is 0, then no motion was detected at all.
> +	    </entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
>      <table pgwide="1" frame="none" id="changes-flags">
>        <title>Changes</title>
>        <tgroup cols="3">
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> 5c70b61..d9c3e66 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -155,6 +155,15 @@
>  	    </entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
> +	    <entry>5</entry>
> +	    <entry>
> +	      <para>Triggered whenever the motion detection state changes, i.e.
> +	      whether motion is detected or not.

Isn't the event also triggered when region_mask changes from a non-zero value 
to a different non-zero value ? The second part of the sentence seems to imply 
that the even is only triggered when motion starts being detected or stops 
being detected.

> This event has a
> +	      &v4l2-event-motion-det; associated with it.</para>
> +	    </entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>  	    <entry>0x08000000</entry>
>  	    <entry>Base event number for driver-private events.</entry>
-- 
Regards,

Laurent Pinchart

