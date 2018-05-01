Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45086 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbeEAI2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2018 04:28:53 -0400
Subject: Re: [PATCH v7 8/8] media: vsp1: Move video configuration to a cached
 dlb
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <397eb3811ec096d0ceefa1dbea2d0ae68feb0587.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <10234110.l0SE7yvkH2@avalon>
 <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b8ebf0d1-5b2b-db3f-0a0d-6458063003a5@ideasonboard.com>
Date: Tue, 1 May 2018 09:28:47 +0100
MIME-Version: 1.0
In-Reply-To: <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="XOEh6GtYX3eePChnnxltxlvRWwwfnafkp"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XOEh6GtYX3eePChnnxltxlvRWwwfnafkp
Content-Type: multipart/mixed; boundary="5DCf52svkyLNvWDuWzVFUk8bFF5QC6lSm";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Message-ID: <b8ebf0d1-5b2b-db3f-0a0d-6458063003a5@ideasonboard.com>
Subject: Re: [PATCH v7 8/8] media: vsp1: Move video configuration to a cached
 dlb
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <397eb3811ec096d0ceefa1dbea2d0ae68feb0587.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <10234110.l0SE7yvkH2@avalon>
 <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>
In-Reply-To: <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>

--5DCf52svkyLNvWDuWzVFUk8bFF5QC6lSm
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

New plan ... (from the .. why didn't I think of this earlier department)



On 30/04/18 18:48, Kieran Bingham wrote:
> Hi Laurent,
>=20
> On 07/04/18 01:23, Laurent Pinchart wrote:
>> Hi Kieran,
>>
>> Thank you for the patch.
>>
>> On Thursday, 8 March 2018 02:05:31 EEST Kieran Bingham wrote:
>>> We are now able to configure a pipeline directly into a local display=

>>> list body. Take advantage of this fact, and create a cacheable body t=
o
>>> store the configuration of the pipeline in the video object.
>>>
>>> vsp1_video_pipeline_run() is now the last user of the pipe->dl object=
=2E
>>> Convert this function to use the cached video->config body and obtain=
 a
>>> local display list reference.
>>>
>>> Attach the video->config body to the display list when needed before
>>> committing to hardware.
>>>
>>> The pipe object is marked as un-configured when resuming from a suspe=
nd.
>>> This ensures that when the hardware is reset - our cached configurati=
on
>>> will be re-attached to the next committed DL.
>>>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.co=
m>
>>> ---
>>>
>>> v3:
>>>  - 's/fragment/body/', 's/fragments/bodies/'
>>>  - video dlb cache allocation increased from 2 to 3 dlbs
>>>
>>> Our video DL usage now looks like the below output:
>>>
>>> dl->body0 contains our disposable runtime configuration. Max 41.
>>> dl_child->body0 is our partition specific configuration. Max 12.
>>> dl->bodies shows our constant configuration and LUTs.
>>>
>>>   These two are LUT/CLU:
>>>      * dl->bodies[x]->num_entries 256 / max 256
>>>      * dl->bodies[x]->num_entries 4914 / max 4914
>>>
>>> Which shows that our 'constant' configuration cache is currently
>>> utilised to a maximum of 64 entries.
>>>
>>> trace-cmd report | \
>>>     grep max | sed 's/.*vsp1_dl_list_commit://g' | sort | uniq;
>>>
>>>   dl->body0->num_entries 13 / max 128
>>>   dl->body0->num_entries 14 / max 128
>>>   dl->body0->num_entries 16 / max 128
>>>   dl->body0->num_entries 20 / max 128
>>>   dl->body0->num_entries 27 / max 128
>>>   dl->body0->num_entries 34 / max 128
>>>   dl->body0->num_entries 41 / max 128
>>>   dl_child->body0->num_entries 10 / max 128
>>>   dl_child->body0->num_entries 12 / max 128
>>>   dl->bodies[x]->num_entries 15 / max 128
>>>   dl->bodies[x]->num_entries 16 / max 128
>>>   dl->bodies[x]->num_entries 17 / max 128
>>>   dl->bodies[x]->num_entries 18 / max 128
>>>   dl->bodies[x]->num_entries 20 / max 128
>>>   dl->bodies[x]->num_entries 21 / max 128
>>>   dl->bodies[x]->num_entries 256 / max 256
>>>   dl->bodies[x]->num_entries 31 / max 128
>>>   dl->bodies[x]->num_entries 32 / max 128
>>>   dl->bodies[x]->num_entries 39 / max 128
>>>   dl->bodies[x]->num_entries 40 / max 128
>>>   dl->bodies[x]->num_entries 47 / max 128
>>>   dl->bodies[x]->num_entries 48 / max 128
>>>   dl->bodies[x]->num_entries 4914 / max 4914
>>>   dl->bodies[x]->num_entries 55 / max 128
>>>   dl->bodies[x]->num_entries 56 / max 128
>>>   dl->bodies[x]->num_entries 63 / max 128
>>>   dl->bodies[x]->num_entries 64 / max 128
>>
>> This might be useful to capture in the main part of the commit message=
=2E
>>
>>> v4:
>>>  - Adjust pipe configured flag to be reset on resume rather than susp=
end
>>>  - rename dl_child, dl_next
>>>
>>>  drivers/media/platform/vsp1/vsp1_pipe.c  |  7 +++-
>>>  drivers/media/platform/vsp1/vsp1_pipe.h  |  4 +-
>>>  drivers/media/platform/vsp1/vsp1_video.c | 67 ++++++++++++++++------=
---
>>>  drivers/media/platform/vsp1/vsp1_video.h |  2 +-
>>>  4 files changed, 54 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
>>> b/drivers/media/platform/vsp1/vsp1_pipe.c index 5012643583b6..fa445b1=
a2e38
>>> 100644
>>> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
>>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
>>> @@ -249,6 +249,7 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pipe=
)
>>>  		vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index),
>>>  			   VI6_CMD_STRCMD);
>>>  		pipe->state =3D VSP1_PIPELINE_RUNNING;
>>> +		pipe->configured =3D true;

Look at that lovely pipe->state flag update right above the pipe->configu=
red
update...

>>>  	}
>>>
>>>  	pipe->buffers_ready =3D 0;
>>> @@ -470,6 +471,12 @@ void vsp1_pipelines_resume(struct vsp1_device *v=
sp1)
>>>  			continue;
>>>
>>>  		spin_lock_irqsave(&pipe->irqlock, flags);
>>> +		/*
>>> +		 * The hardware may have been reset during a suspend and will
>>> +		 * need a full reconfiguration
>>> +		 */
>>
>> s/reconfiguration/reconfiguration./
>>
>>> +		pipe->configured =3D false;

If we have 'suspended' then pipe->state =3D=3D STOPPED


>>> +
>>
>> Where does that full reconfiguration occur, given that the vsp1_pipeli=
ne_run()=20
>> right below sets pipe->configured to true without performing reconfigu=
ration ?
>=20
> It's magic isn't it :D
>=20
> If the pipe->configured flag gets set to false, the next execution of
> vsp1_pipeline_run() attaches the video->pipe_config (the cached configu=
ration,
> containing the route_setup() and the configure_stream() entries) to the=
 display
> list before configuring for the next frame.
>=20
> This means that the hardware gets a full configuration written to it af=
ter a
> suspend/resume action.
>=20
> Perhaps the comment should say "The video object will write out it's ca=
ched pipe
> configuration on the next display list commit"
>=20
>=20
>>
>>>  		if (vsp1_pipeline_ready(pipe))
>>>  			vsp1_pipeline_run(pipe);

>>>  		spin_unlock_irqrestore(&pipe->irqlock, flags);
>>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
>>> b/drivers/media/platform/vsp1/vsp1_pipe.h index 90d29492b9b9..e7ad621=
1b4d0
>>> 100644
>>> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
>>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
>>> @@ -90,6 +90,7 @@ struct vsp1_partition {
>>>   * @irqlock: protects the pipeline state
>>>   * @state: current state
>>>   * @wq: wait queue to wait for state change completion
>>> + * @configured: flag determining if the hardware has run since reset=


I think this flag can now be removed...

>>>   * @frame_end: frame end interrupt handler
>>>   * @lock: protects the pipeline use count and stream count
>>>   * @kref: pipeline reference count
>>> @@ -117,6 +118,7 @@ struct vsp1_pipeline {
>>>  	spinlock_t irqlock;
>>>  	enum vsp1_pipeline_state state;
>>>  	wait_queue_head_t wq;
>>> +	bool configured;

and here of course...

>>>
>>>  	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
>>>
>>> @@ -143,8 +145,6 @@ struct vsp1_pipeline {
>>>  	 */
>>>  	struct list_head entities;
>>>
>>> -	struct vsp1_dl_list *dl;
>>> -
>>
>> You should remove the corresponding line from the structure documentat=
ion.
>=20
> Done.
>=20
>>
>>>  	unsigned int partitions;
>>>  	struct vsp1_partition *partition;
>>>  	struct vsp1_partition *part_table;
>>> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
>>> b/drivers/media/platform/vsp1/vsp1_video.c index b47708660e53..96d987=
2667d9
>>> 100644
>>> --- a/drivers/media/platform/vsp1/vsp1_video.c
>>> +++ b/drivers/media/platform/vsp1/vsp1_video.c
>>> @@ -394,37 +394,43 @@ static void vsp1_video_pipeline_run_partition(s=
truct
>>> vsp1_pipeline *pipe, static void vsp1_video_pipeline_run(struct
>>> vsp1_pipeline *pipe)
>>>  {
>>>  	struct vsp1_device *vsp1 =3D pipe->output->entity.vsp1;
>>> +	struct vsp1_video *video =3D pipe->output->video;
>>>  	unsigned int partition;
>>> +	struct vsp1_dl_list *dl;
>>> +
>>> +	dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>>
>>> -	if (!pipe->dl)
>>> -		pipe->dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>> +	/* Attach our pipe configuration to fully initialise the hardware *=
/
>>
>> s/hardware/hardware./
>>
>> There are other similar comments in this patch.

I think I've fixed these up.

>>
>>> +	if (!pipe->configured) {

So - if this line, instead of reading !pipe->configured was:

+	if (vsp1_pipeline_stopped(pipe)) {

>>> +		vsp1_dl_list_add_body(dl, video->pipe_config);
>>> +		pipe->configured =3D true;

Then we don't need to update the flag, or access the pipe internals.

>>> +	}




>>>
>>>  	/* Run the first partition */
>>> -	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
>>> +	vsp1_video_pipeline_run_partition(pipe, dl, 0);
>>>
>>>  	/* Process consecutive partitions as necessary */
>>>  	for (partition =3D 1; partition < pipe->partitions; ++partition) {
>>> -		struct vsp1_dl_list *dl;
>>> +		struct vsp1_dl_list *dl_next;
>>>
>>> -		dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>> +		dl_next =3D vsp1_dl_list_get(pipe->output->dlm);
>>>
>>>  		/*
>>>  		 * An incomplete chain will still function, but output only
>>>  		 * the partitions that had a dl available. The frame end
>>>  		 * interrupt will be marked on the last dl in the chain.
>>>  		 */
>>> -		if (!dl) {
>>> +		if (!dl_next) {
>>>  			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be
>>> incomplete\n"); break;
>>>  		}
>>>
>>> -		vsp1_video_pipeline_run_partition(pipe, dl, partition);
>>> -		vsp1_dl_list_add_chain(pipe->dl, dl);
>>> +		vsp1_video_pipeline_run_partition(pipe, dl_next, partition);
>>> +		vsp1_dl_list_add_chain(dl, dl_next);
>>>  	}
>>>
>>>  	/* Complete, and commit the head display list. */
>>> -	vsp1_dl_list_commit(pipe->dl);
>>> -	pipe->dl =3D NULL;
>>> +	vsp1_dl_list_commit(dl);
>>>
>>>  	vsp1_pipeline_run(pipe);
>>>  }
>>> @@ -790,8 +796,8 @@ static void vsp1_video_buffer_queue(struct vb2_bu=
ffer
>>> *vb)
>>>
>>>  static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>>>  {
>>> +	struct vsp1_video *video =3D pipe->output->video;
>>>  	struct vsp1_entity *entity;
>>> -	struct vsp1_dl_body *dlb;
>>>  	int ret;
>>>
>>>  	/* Determine this pipelines sizes for image partitioning support. *=
/
>>> @@ -799,14 +805,6 @@ static int vsp1_video_setup_pipeline(struct
>>> vsp1_pipeline *pipe) if (ret < 0)
>>>  		return ret;
>>>
>>> -	/* Prepare the display list. */
>>> -	pipe->dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>> -	if (!pipe->dl)
>>> -		return -ENOMEM;
>>> -
>>> -	/* Retrieve the default DLB from the list */
>>> -	dlb =3D vsp1_dl_list_get_body0(pipe->dl);
>>> -
>>>  	if (pipe->uds) {
>>>  		struct vsp1_uds *uds =3D to_uds(&pipe->uds->subdev);
>>>
>>> @@ -828,11 +826,20 @@ static int vsp1_video_setup_pipeline(struct
>>> vsp1_pipeline *pipe) }
>>>  	}
>>>
>>> +	/* Obtain a clean body from our pool */
>>> +	video->pipe_config =3D vsp1_dl_body_get(video->dlbs);
>>> +	if (!video->pipe_config)
>>> +		return -ENOMEM;
>>> +
>>> +	/* Configure the entities into our cached pipe configuration */
>>>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>>> -		vsp1_entity_route_setup(entity, pipe, dlb);
>>> -		vsp1_entity_configure_stream(entity, pipe, dlb);
>>> +		vsp1_entity_route_setup(entity, pipe, video->pipe_config);
>>> +		vsp1_entity_configure_stream(entity, pipe, video->pipe_config);
>>>  	}
>>>
>>> +	/* Ensure that our cached configuration is updated in the next DL *=
/
>>> +	pipe->configured =3D false;
>>
>> Quoting my comment to a previous version, and your reply to it which I=
 have=20
>> failed to answer,
>>
>>>> I'm tempted to move this at pipeline stop time (either to
>>>> vsp1_video_stop_streaming() right after the vsp1_pipeline_stop() cal=
l, or
>>>> in vsp1_pipeline_stop() itself), possibly with a WARN_ON() here to c=
atch
>>>> bugs in the driver.
>>>
>>> Do you mean just setting the flag? or the pipe_configuration? This is=
 a
>>> setup task - not a stop task ... ? We are doing this as part of
>>> vsp1_video_start_streaming().
>>
>> I meant just setting the configured flag back to false.
>=20
> The point at this line in the code is to ensure that the flag is set fa=
lse,
> because all of that stream configuration isn't included in the display =
list -
> unless the flag is false.
>=20
> If the flag is initialised false in object creation, and stream stop - =
then
> that's fine. I felt like setting it false here was appropriate because =
as soon
> as the video->pipe_config cache is populated - that's the time it also =
needs to
> be 'flushed' to the hardware through the next dl_commit()
>=20
>>
>>> IMO, The flag should only be updated after the configuration has been=

>>> updated to signal that the new configuration should be written out to=
 the
>>> hardware.
>>>
>>> Unless you mean to mark the pipe->configured =3D false; at
>>> vsp1_pipeline_stop() time because we reset the pipe to halt it ?
>>
>> That's the idea, yes. And now that I think about it again, we could al=
so set=20
>> pipe->configured to false in vsp1_video_cleanup_pipeline() right after=
 the=20
>> vsp1_dl_body_put() call.
>>
>> What bothers me here is that the pipe->configured flag is handled both=
 in=20
>> vsp1_pipe.c and vsp1_video.c. Coupled with my above comment about the =
full=20
>> reconfiguration at resume time,=20
>=20
> Which comment - the one saying it doesn't happen? (It does... it uses t=
he cached
> configuration)
>=20
>> I think we might not be abstracting this as we=20
>> should. I wonder whether it would be possible to either make the flag =
local to=20
>> vsp1_pipe.c, or local to vsp1_video.c and move it from the pipeline ob=
ject to=20
>> the video object. My gut feeling right now (and it might be too late t=
o trust=20
>> it) is that, as the pipe_config object is stored in vsp1_video, so sho=
uld the=20
>> configured flag.
>>
>> Please feel free to challenge this.
>=20
> The flag is in the pipe because that's accessible at resume time. I cou=
ld
> provide accessors so that it's not modified directly from the vsp_video=
 object?
>=20
> But the configuration cache is specific to the video object - which is =
why it's
> in there...
>=20
> I'm not sure that the pipeline vsp1_pipelines_resume() can modify flags=
 in the
> video object at resume time though ... which would be the other directi=
on of
> approaching this ...


So summarising my inlines above...

Yes, currently this patch is modifying a flag based on the hardware state=
 to
know when to apply the current cached configuration to the next outgoing =
display
list.

We don't need to have a flag (or the cross-object pollution) because I be=
lieve
we can use the pipe->state status to tell us the exact information we nee=
d.
(when the pipeline has stopped, and thus needs to have the routing and st=
ream
information sent to hardware)

I'll try it out - and hopefully send a v8... that I'm happy with :D



--
Kieran



>=20
>>
>>> +
>>>  	return 0;
>>>  }
>>>
>>> @@ -842,6 +849,9 @@ static void vsp1_video_cleanup_pipeline(struct
>>> vsp1_pipeline *pipe) struct vsp1_vb2_buffer *buffer;
>>>  	unsigned long flags;
>>>
>>> +	/* Release any cached configuration */
>>> +	vsp1_dl_body_put(video->pipe_config);
>>> +
>>>  	/* Remove all buffers from the IRQ queue. */
>>>  	spin_lock_irqsave(&video->irqlock, flags);
>>>  	list_for_each_entry(buffer, &video->irqqueue, queue)
>>> @@ -918,9 +928,6 @@ static void vsp1_video_stop_streaming(struct vb2_=
queue
>>> *vq) ret =3D vsp1_pipeline_stop(pipe);
>>>  		if (ret =3D=3D -ETIMEDOUT)
>>>  			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
>>> -
>>> -		vsp1_dl_list_put(pipe->dl);
>>> -		pipe->dl =3D NULL;
>>>  	}
>>>  	mutex_unlock(&pipe->lock);
>>>
>>> @@ -1240,6 +1247,16 @@ struct vsp1_video *vsp1_video_create(struct
>>> vsp1_device *vsp1, goto error;
>>>  	}
>>>
>>> +	/*
>>> +	 * Utilise a body pool to cache the constant configuration of the
>>> +	 * pipeline object.
>>> +	 */
>>> +	video->dlbs =3D vsp1_dl_body_pool_create(vsp1, 3, 128, 0);
>>> +	if (!video->dlbs) {
>>> +		ret =3D -ENOMEM;
>>> +		goto error;
>>> +	}
>>> +
>>>  	return video;
>>>
>>>  error:
>>> @@ -1249,6 +1266,8 @@ struct vsp1_video *vsp1_video_create(struct
>>> vsp1_device *vsp1,
>>>
>>>  void vsp1_video_cleanup(struct vsp1_video *video)
>>>  {
>>> +	vsp1_dl_body_pool_destroy(video->dlbs);
>>> +
>>>  	if (video_is_registered(&video->video))
>>>  		video_unregister_device(&video->video);
>>>
>>> diff --git a/drivers/media/platform/vsp1/vsp1_video.h
>>> b/drivers/media/platform/vsp1/vsp1_video.h index 50ea7f02205f..e84f8e=
e902c1
>>> 100644
>>> --- a/drivers/media/platform/vsp1/vsp1_video.h
>>> +++ b/drivers/media/platform/vsp1/vsp1_video.h
>>> @@ -43,6 +43,8 @@ struct vsp1_video {
>>>
>>>  	struct mutex lock;
>>>
>>> +	struct vsp1_dl_body_pool *dlbs;
>>> +	struct vsp1_dl_body *pipe_config;
>>>  	unsigned int pipe_index;
>>>
>>>  	struct vb2_queue queue;
>>


--5DCf52svkyLNvWDuWzVFUk8bFF5QC6lSm--

--XOEh6GtYX3eePChnnxltxlvRWwwfnafkp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlroJT8ACgkQoR5GchCk
Yf3l/A//QJI3iFpV0ehtVez+DxKmCcoCXWU6LH+K7qjrnt3SSoqw6TsfjEpm7b90
C+ZipyeaP/lUxlLxgjvVtFBn4o9VqF8rOgI1+xCMiXtjB11f2i6hLkE9R4EZoPgr
OI/iAGe4+C6ZWAvlp89EHq2apcp4tnlKoVQIOUVI6Z3g2BmnI8YiVHF9rLuW9Duh
xwYYroinpHJjhuUikE5wBBKg8NxB4hEMf2kr3lP6Kuk84fiDXXN6kDJDt62XOF1X
ZefGhDeCtN3vp6o6G0Z8MbeunIQURkVDobALuLMRrYo9+aXOiu5OwIFNkC5zs9PP
q1MrvWYues7O6n0KPMr6ONueik845Fz+dPwsOTNHDC+4INaxsb/Tulla5zQQdb/l
vJDuhrvQjih4yI9uVvSBDyMWg5gIB6N1niClxqX4h0IQykihc6mNKtKyLM//PJzX
fNwnWMrXv3rbXwffpdIf+KQpiQ4tr8yq/KWb0CU8umtlVMj9cfYUrJQKYHOWLmxf
OJnCIWDwpEdfnVLAqUrNrTPAwZuF/ERdYW02mkVBAbSeq7T9T5ek3iYiSICskMSf
iYiTqaZYiLP84Y1b1U6Vmbtgkf1+qyhtTO7NvqVsI72fMX/RyHBOeCcouumWrgcJ
Jrh9Fz/jRmZINWLCY1IG6JbXfhraYXjIvFxO0Hf/eDn+XHJWHy0=
=o0f1
-----END PGP SIGNATURE-----

--XOEh6GtYX3eePChnnxltxlvRWwwfnafkp--
