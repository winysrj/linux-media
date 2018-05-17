Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50544 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeEQRGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 13:06:52 -0400
Subject: Re: [PATCH v7 8/8] media: vsp1: Move video configuration to a cached
 dlb
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <10234110.l0SE7yvkH2@avalon>
 <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>
 <2574394.aYb3RYBsUT@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <00b80250-27dc-4cde-fbce-9fd6e1646864@ideasonboard.com>
Date: Thu, 17 May 2018 18:06:46 +0100
MIME-Version: 1.0
In-Reply-To: <2574394.aYb3RYBsUT@avalon>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="liEBRWh70EtGAjVIOYSGFuEVZo24vk9Jk"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--liEBRWh70EtGAjVIOYSGFuEVZo24vk9Jk
Content-Type: multipart/mixed; boundary="qcnIR43OCl5UrgiuJilwM4wOdLKD0w8ex";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Message-ID: <00b80250-27dc-4cde-fbce-9fd6e1646864@ideasonboard.com>
Subject: Re: [PATCH v7 8/8] media: vsp1: Move video configuration to a cached
 dlb
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
 <10234110.l0SE7yvkH2@avalon>
 <066d4c14-5b92-bc99-d82a-d44df4a32726@ideasonboard.com>
 <2574394.aYb3RYBsUT@avalon>
In-Reply-To: <2574394.aYb3RYBsUT@avalon>

--qcnIR43OCl5UrgiuJilwM4wOdLKD0w8ex
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 17/05/18 15:35, Laurent Pinchart wrote:
> Hi Kieran,
>=20
> On Monday, 30 April 2018 20:48:03 EEST Kieran Bingham wrote:
>> On 07/04/18 01:23, Laurent Pinchart wrote:
>>> On Thursday, 8 March 2018 02:05:31 EEST Kieran Bingham wrote:
>>>> We are now able to configure a pipeline directly into a local displa=
y
>>>> list body. Take advantage of this fact, and create a cacheable body =
to
>>>> store the configuration of the pipeline in the video object.
>>>>
>>>> vsp1_video_pipeline_run() is now the last user of the pipe->dl objec=
t.
>>>> Convert this function to use the cached video->config body and obtai=
n a
>>>> local display list reference.
>>>>
>>>> Attach the video->config body to the display list when needed before=

>>>> committing to hardware.
>>>>
>>>> The pipe object is marked as un-configured when resuming from a susp=
end.
>>>> This ensures that when the hardware is reset - our cached configurat=
ion
>>>> will be re-attached to the next committed DL.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.c=
om>
>>>> ---
>>>>
>>>> v3:
>>>>  - 's/fragment/body/', 's/fragments/bodies/'
>>>>  - video dlb cache allocation increased from 2 to 3 dlbs
>>>>
>>>> Our video DL usage now looks like the below output:
>>>>
>>>> dl->body0 contains our disposable runtime configuration. Max 41.
>>>> dl_child->body0 is our partition specific configuration. Max 12.
>>>> dl->bodies shows our constant configuration and LUTs.
>>>>
>>>>   These two are LUT/CLU:
>>>>      * dl->bodies[x]->num_entries 256 / max 256
>>>>      * dl->bodies[x]->num_entries 4914 / max 4914
>>>>
>>>> Which shows that our 'constant' configuration cache is currently
>>>> utilised to a maximum of 64 entries.
>>>>
>>>> trace-cmd report | \
>>>>
>>>>     grep max | sed 's/.*vsp1_dl_list_commit://g' | sort | uniq;
>>>>  =20
>>>>   dl->body0->num_entries 13 / max 128
>>>>   dl->body0->num_entries 14 / max 128
>>>>   dl->body0->num_entries 16 / max 128
>>>>   dl->body0->num_entries 20 / max 128
>>>>   dl->body0->num_entries 27 / max 128
>>>>   dl->body0->num_entries 34 / max 128
>>>>   dl->body0->num_entries 41 / max 128
>>>>   dl_child->body0->num_entries 10 / max 128
>>>>   dl_child->body0->num_entries 12 / max 128
>>>>   dl->bodies[x]->num_entries 15 / max 128
>>>>   dl->bodies[x]->num_entries 16 / max 128
>>>>   dl->bodies[x]->num_entries 17 / max 128
>>>>   dl->bodies[x]->num_entries 18 / max 128
>>>>   dl->bodies[x]->num_entries 20 / max 128
>>>>   dl->bodies[x]->num_entries 21 / max 128
>>>>   dl->bodies[x]->num_entries 256 / max 256
>>>>   dl->bodies[x]->num_entries 31 / max 128
>>>>   dl->bodies[x]->num_entries 32 / max 128
>>>>   dl->bodies[x]->num_entries 39 / max 128
>>>>   dl->bodies[x]->num_entries 40 / max 128
>>>>   dl->bodies[x]->num_entries 47 / max 128
>>>>   dl->bodies[x]->num_entries 48 / max 128
>>>>   dl->bodies[x]->num_entries 4914 / max 4914
>>>>   dl->bodies[x]->num_entries 55 / max 128
>>>>   dl->bodies[x]->num_entries 56 / max 128
>>>>   dl->bodies[x]->num_entries 63 / max 128
>>>>   dl->bodies[x]->num_entries 64 / max 128
>>>
>>> This might be useful to capture in the main part of the commit messag=
e.
>>>
>>>> v4:
>>>>  - Adjust pipe configured flag to be reset on resume rather than sus=
pend
>>>>  - rename dl_child, dl_next
>>>> =20
>>>>  drivers/media/platform/vsp1/vsp1_pipe.c  |  7 +++-
>>>>  drivers/media/platform/vsp1/vsp1_pipe.h  |  4 +-
>>>>  drivers/media/platform/vsp1/vsp1_video.c | 67 ++++++++++++++++-----=
----
>>>>  drivers/media/platform/vsp1/vsp1_video.h |  2 +-
>>>>  4 files changed, 54 insertions(+), 26 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
>>>> b/drivers/media/platform/vsp1/vsp1_pipe.c index
>>>> 5012643583b6..fa445b1a2e38
>>>> 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
>>>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
>>>> @@ -249,6 +249,7 @@ void vsp1_pipeline_run(struct vsp1_pipeline *pip=
e)
>>>>  		vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index),
>>>>  			   VI6_CMD_STRCMD);
>>>>  		pipe->state =3D VSP1_PIPELINE_RUNNING;
>>>> +		pipe->configured =3D true;
>>>>  	}
>>>>  =09
>>>>  	pipe->buffers_ready =3D 0;
>>>> @@ -470,6 +471,12 @@ void vsp1_pipelines_resume(struct vsp1_device *=
vsp1)
>>>>  			continue;
>>>>  	=09
>>>>  		spin_lock_irqsave(&pipe->irqlock, flags);
>>>> +		/*
>>>> +		 * The hardware may have been reset during a suspend and will
>>>> +		 * need a full reconfiguration
>>>> +		 */
>>>
>>> s/reconfiguration/reconfiguration./
>>>
>>>> +		pipe->configured =3D false;
>>>> +
>>>
>>> Where does that full reconfiguration occur, given that the
>>> vsp1_pipeline_run() right below sets pipe->configured to true without=

>>> performing reconfiguration ?
> Q=20
>> It's magic isn't it :D
>>
>> If the pipe->configured flag gets set to false, the next execution of
>> vsp1_pipeline_run() attaches the video->pipe_config (the cached
>> configuration, containing the route_setup() and the configure_stream()=

>> entries) to the display list before configuring for the next frame.
>=20
> Unless I'm mistaken, it's vsp1_video_pipeline_run() that does so, not=20
> vsp1_pipeline_run().


Aha - ok - I think I see the issue.

1) Yes - you are correct - vsp1_video_pipeline_run() adds the full cached=

configuration to the display list, to ensure that the routes are re-confi=
gured
after a resume.


>=20
>> This means that the hardware gets a full configuration written to it a=
fter a
>> suspend/resume action.
>>
>> Perhaps the comment should say "The video object will write out it's c=
ached
>> pipe configuration on the next display list commit"
>>
>>>>  		if (vsp1_pipeline_ready(pipe))

2) ... Although the next line is a call to vsp1_pipeline_run(), upon a re=
sume
for a video pipeline - I believe vsp1_pipeline_ready() is false, (we will=
 have
gone through STOPPING, STOPPED) thus it won't run until the *next* iterat=
ion. DU
pipelines will not be affected by the usage pipe->configured flag...

>>>>  			vsp1_pipeline_run(pipe);


However - now I see it - yes this feels a bit ugly in that regards, and n=
ow
feels like it's only worked by chance rather than design! :-(

Hrm ... in fact as there will be no active DL committed for the pipeline =
- is it
ever possible for the above vsp1_pipeline_run() to start the pipeline ? S=
o it's
not chance at least :D


Perhaps instead of adding the configured flag, I could add the cached dlb=

configuration if the pipe->state is STOPPED ...

 ... I feel like I've already tried to go down the route of using the
pipe->state though ...


Ok - a quick attempt, and I've removed the pipe->configured flag - and ch=
anged
the attach as follows:

	/* Attach our pipe configuration to fully initialise the hardware */
	if (!pipe->state =3D=3D VSP1_PIPELINE_STOPPED)
		vsp1_dl_list_add_body(dl, video->pipe_config);

This is 'cleaner' I think as it doesn't add an extra flag - but relies up=
on the
exact same circumstance that the pipe->state is not set to running at res=
ume
time (which I believe to be OK).

It also passes the relevant tests on vsp-tests:

root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0000.sh
Test Conditions:
  Platform          Renesas Salvator-X 2nd version board based on r8a7795=
 ES2.0+
  Kernel release    4.17.0-rc4-arm64-renesas-00397-g3d2f6f2901b0
  convert           /usr/bin/convert
  compare           /usr/bin/compare
  killall           /usr/bin/killall
  raw2rgbpnm        /usr/bin/raw2rgbpnm
  stress            /usr/bin/stress
  yavta             /usr/bin/yavta

root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0019.sh
Testing non-active pipeline suspend/resume in suspend:freezer: passed
Testing non-active pipeline suspend/resume in suspend:devices: passed
Testing non-active pipeline suspend/resume in suspend:platform: passed
Testing non-active pipeline suspend/resume in suspend:processors: passed
Testing non-active pipeline suspend/resume in suspend:core: passed

root@Ubuntu-ARM64:~/vsp-tests# ./vsp-unit-test-0020.sh
Testing Testing active pipeline suspend/resume in suspend:freezer: pass
Testing Testing active pipeline suspend/resume in suspend:devices: pass
Testing Testing active pipeline suspend/resume in suspend:platform: pass
Testing Testing active pipeline suspend/resume in suspend:processors: pas=
s
Testing Testing active pipeline suspend/resume in suspend:core: pass


--
Kieran


>>>>  		spin_unlock_irqrestore(&pipe->irqlock, flags);
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
>>>> b/drivers/media/platform/vsp1/vsp1_pipe.h index
>>>> 90d29492b9b9..e7ad6211b4d0
>>>> 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
>>>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
>>>> @@ -90,6 +90,7 @@ struct vsp1_partition {
>>>>   * @irqlock: protects the pipeline state
>>>>   * @state: current state
>>>>   * @wq: wait queue to wait for state change completion
>>>> + * @configured: flag determining if the hardware has run since rese=
t
>>>>   * @frame_end: frame end interrupt handler
>>>>   * @lock: protects the pipeline use count and stream count
>>>>   * @kref: pipeline reference count
>>>> @@ -117,6 +118,7 @@ struct vsp1_pipeline {
>>>>  	spinlock_t irqlock;
>>>>  	enum vsp1_pipeline_state state;
>>>>  	wait_queue_head_t wq;
>>>> +	bool configured;
>>>>
>>>>  	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
>>>>
>>>> @@ -143,8 +145,6 @@ struct vsp1_pipeline {
>>>>  	 */
>>>>  	struct list_head entities;
>>>>
>>>> -	struct vsp1_dl_list *dl;
>>>> -
>>>
>>> You should remove the corresponding line from the structure documenta=
tion.
>>
>> Done.
>>
>>>>  	unsigned int partitions;
>>>>  	struct vsp1_partition *partition;
>>>>  	struct vsp1_partition *part_table;
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
>>>> b/drivers/media/platform/vsp1/vsp1_video.c index
>>>> b47708660e53..96d9872667d9
>>>> 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_video.c
>>>> +++ b/drivers/media/platform/vsp1/vsp1_video.c
>>>> @@ -394,37 +394,43 @@ static void
>>>> vsp1_video_pipeline_run_partition(struct
>>>> vsp1_pipeline *pipe, static void vsp1_video_pipeline_run(struct
>>>> vsp1_pipeline *pipe)
>>>>  {
>>>>  	struct vsp1_device *vsp1 =3D pipe->output->entity.vsp1;
>>>> +	struct vsp1_video *video =3D pipe->output->video;
>>>>  	unsigned int partition;
>>>> +	struct vsp1_dl_list *dl;
>>>> +
>>>> +	dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>>>
>>>> -	if (!pipe->dl)
>>>> -		pipe->dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>>> +	/* Attach our pipe configuration to fully initialise the hardware =
*/
>>>
>>> s/hardware/hardware./
>>>
>>> There are other similar comments in this patch.
>>>
>>>> +	if (!pipe->configured) {
>>>> +		vsp1_dl_list_add_body(dl, video->pipe_config);
>>>> +		pipe->configured =3D true;
>>>> +	}
>>>>
>>>>  	/* Run the first partition */
>>>> -	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
>>>> +	vsp1_video_pipeline_run_partition(pipe, dl, 0);
>>>>
>>>>  	/* Process consecutive partitions as necessary */
>>>>  	for (partition =3D 1; partition < pipe->partitions; ++partition) {=

>>>> -		struct vsp1_dl_list *dl;
>>>> +		struct vsp1_dl_list *dl_next;
>>>>
>>>> -		dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>>> +		dl_next =3D vsp1_dl_list_get(pipe->output->dlm);
>>>>
>>>>  		/*
>>>>  		 * An incomplete chain will still function, but output only
>>>>  		 * the partitions that had a dl available. The frame end
>>>>  		 * interrupt will be marked on the last dl in the chain.
>>>>  		 */
>>>> -		if (!dl) {
>>>> +		if (!dl_next) {
>>>>  			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be
>>>> incomplete\n");
>>>>  			break;
>>>>  		}
>>>>
>>>> -		vsp1_video_pipeline_run_partition(pipe, dl, partition);
>>>> -		vsp1_dl_list_add_chain(pipe->dl, dl);
>>>> +		vsp1_video_pipeline_run_partition(pipe, dl_next, partition);
>>>> +		vsp1_dl_list_add_chain(dl, dl_next);
>>>>  	}
>>>>  =09
>>>>  	/* Complete, and commit the head display list. */
>>>> -	vsp1_dl_list_commit(pipe->dl);
>>>> -	pipe->dl =3D NULL;
>>>> +	vsp1_dl_list_commit(dl);
>>>>
>>>>  	vsp1_pipeline_run(pipe);
>>>>  }
>>>> @@ -790,8 +796,8 @@ static void vsp1_video_buffer_queue(struct vb2_b=
uffer
>>>> *vb)
>>>>
>>>>  static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>>>>  {
>>>> +	struct vsp1_video *video =3D pipe->output->video;
>>>>  	struct vsp1_entity *entity;
>>>> -	struct vsp1_dl_body *dlb;
>>>>  	int ret;
>>>>  =09
>>>>  	/* Determine this pipelines sizes for image partitioning support. =
*/
>>>> @@ -799,14 +805,6 @@ static int vsp1_video_setup_pipeline(struct
>>>> vsp1_pipeline *pipe)
>>>>  	if (ret < 0)
>>>>  		return ret;
>>>>
>>>> -	/* Prepare the display list. */
>>>> -	pipe->dl =3D vsp1_dl_list_get(pipe->output->dlm);
>>>> -	if (!pipe->dl)
>>>> -		return -ENOMEM;
>>>> -
>>>> -	/* Retrieve the default DLB from the list */
>>>> -	dlb =3D vsp1_dl_list_get_body0(pipe->dl);
>>>> -
>>>>  	if (pipe->uds) {
>>>>  		struct vsp1_uds *uds =3D to_uds(&pipe->uds->subdev);
>>>>
>>>> @@ -828,11 +826,20 @@ static int vsp1_video_setup_pipeline(struct
>>>> vsp1_pipeline *pipe)
>>>>  		}
>>>>  	}
>>>>
>>>> +	/* Obtain a clean body from our pool */
>>>> +	video->pipe_config =3D vsp1_dl_body_get(video->dlbs);
>>>> +	if (!video->pipe_config)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	/* Configure the entities into our cached pipe configuration */
>>>>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>>>> -		vsp1_entity_route_setup(entity, pipe, dlb);
>>>> -		vsp1_entity_configure_stream(entity, pipe, dlb);
>>>> +		vsp1_entity_route_setup(entity, pipe, video->pipe_config);
>>>> +		vsp1_entity_configure_stream(entity, pipe, video->pipe_config);
>>>>  	}
>>>>
>>>> +	/* Ensure that our cached configuration is updated in the next DL =
*/
>>>> +	pipe->configured =3D false;


>>>
>>> Quoting my comment to a previous version, and your reply to it which =
I
>>> have failed to answer,
>>>
>>>>> I'm tempted to move this at pipeline stop time (either to
>>>>> vsp1_video_stop_streaming() right after the vsp1_pipeline_stop() ca=
ll,
>>>>> or in vsp1_pipeline_stop() itself), possibly with a WARN_ON() here =
to
>>>>> catch bugs in the driver.
>>>>
>>>> Do you mean just setting the flag? or the pipe_configuration? This i=
s a
>>>> setup task - not a stop task ... ? We are doing this as part of
>>>> vsp1_video_start_streaming().
>>>
>>> I meant just setting the configured flag back to false.
>>
>> The point at this line in the code is to ensure that the flag is set f=
alse,
>> because all of that stream configuration isn't included in the display=
 list
>> - unless the flag is false.
>>
>> If the flag is initialised false in object creation, and stream stop -=
 then
>> that's fine. I felt like setting it false here was appropriate because=
 as
>> soon as the video->pipe_config cache is populated - that's the time it=
 also
>> needs to be 'flushed' to the hardware through the next dl_commit()
>>
>>>> IMO, The flag should only be updated after the configuration has bee=
n
>>>> updated to signal that the new configuration should be written out t=
o the
>>>> hardware.
>>>>
>>>> Unless you mean to mark the pipe->configured =3D false; at
>>>> vsp1_pipeline_stop() time because we reset the pipe to halt it ?
>>>
>>> That's the idea, yes. And now that I think about it again, we could a=
lso
>>> set pipe->configured to false in vsp1_video_cleanup_pipeline() right
>>> after the vsp1_dl_body_put() call.
>>>
>>> What bothers me here is that the pipe->configured flag is handled bot=
h in
>>> vsp1_pipe.c and vsp1_video.c. Coupled with my above comment about the=
 full
>>> reconfiguration at resume time,
>>
>> Which comment - the one saying it doesn't happen? (It does... it uses =
the
>> cached configuration)
>=20
> As far as I understand it still doesn't :-)
>=20
>>> I think we might not be abstracting this as we should. I wonder wheth=
er it
>>> would be possible to either make the flag local to vsp1_pipe.c, or lo=
cal
>>> to vsp1_video.c and move it from the pipeline object to the video obj=
ect.
>>> My gut feeling right now (and it might be too late to trust it) is th=
at,
>>> as the pipe_config object is stored in vsp1_video, so should the
>>> configured flag.
>>>
>>> Please feel free to challenge this.
>>
>> The flag is in the pipe because that's accessible at resume time. I co=
uld
>> provide accessors so that it's not modified directly from the vsp_vide=
o
>> object?
>>
>> But the configuration cache is specific to the video object - which is=
 why
>> it's in there...
>>
>> I'm not sure that the pipeline vsp1_pipelines_resume() can modify flag=
s in
>> the video object at resume time though ... which would be the other
>> direction of approaching this ...
>>
>>>> +
>>>>  	return 0;
>>>>  }
>>>>
>>>> @@ -842,6 +849,9 @@ static void vsp1_video_cleanup_pipeline(struct
>>>> vsp1_pipeline *pipe)
>>>>  	struct vsp1_vb2_buffer *buffer;
>>>>  	unsigned long flags;
>>>>
>>>> +	/* Release any cached configuration */
>>>> +	vsp1_dl_body_put(video->pipe_config);
>>>> +
>>>>  	/* Remove all buffers from the IRQ queue. */
>>>>  	spin_lock_irqsave(&video->irqlock, flags);
>>>>  	list_for_each_entry(buffer, &video->irqqueue, queue)
>>>> @@ -918,9 +928,6 @@ static void vsp1_video_stop_streaming(struct
>>>> vb2_queue *vq)
>>>>  		ret =3D vsp1_pipeline_stop(pipe);
>>>>  		if (ret =3D=3D -ETIMEDOUT)
>>>>  			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
>>>> -
>>>> -		vsp1_dl_list_put(pipe->dl);
>>>> -		pipe->dl =3D NULL;
>>>>  	}
>>>>  	mutex_unlock(&pipe->lock);
>>>>
>>>> @@ -1240,6 +1247,16 @@ struct vsp1_video *vsp1_video_create(struct
>>>> vsp1_device *vsp1,
>>>>  		goto error;
>>>>  	}
>>>>
>>>> +	/*
>>>> +	 * Utilise a body pool to cache the constant configuration of the
>>>> +	 * pipeline object.
>>>> +	 */
>>>> +	video->dlbs =3D vsp1_dl_body_pool_create(vsp1, 3, 128, 0);
>>>> +	if (!video->dlbs) {
>>>> +		ret =3D -ENOMEM;
>>>> +		goto error;
>>>> +	}
>>>> +
>>>>  	return video;
>>>> =20
>>>>  error:
>>>> @@ -1249,6 +1266,8 @@ struct vsp1_video *vsp1_video_create(struct
>>>> vsp1_device *vsp1,
>>>>
>>>>  void vsp1_video_cleanup(struct vsp1_video *video)
>>>>  {
>>>> +	vsp1_dl_body_pool_destroy(video->dlbs);
>>>> +
>>>>  	if (video_is_registered(&video->video))
>>>>  		video_unregister_device(&video->video);
>>>>
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_video.h
>>>> b/drivers/media/platform/vsp1/vsp1_video.h index
>>>> 50ea7f02205f..e84f8ee902c1
>>>> 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_video.h
>>>> +++ b/drivers/media/platform/vsp1/vsp1_video.h
>>>> @@ -43,6 +43,8 @@ struct vsp1_video {
>>>>
>>>>  	struct mutex lock;
>>>>
>>>> +	struct vsp1_dl_body_pool *dlbs;
>>>> +	struct vsp1_dl_body *pipe_config;
>>>>  	unsigned int pipe_index;
>>>>  =09
>>>>  	struct vb2_queue queue;
>=20


--qcnIR43OCl5UrgiuJilwM4wOdLKD0w8ex--

--liEBRWh70EtGAjVIOYSGFuEVZo24vk9Jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlr9tqYACgkQoR5GchCk
Yf0jwQ/9GcVD6WPEFeQiDgohqvPrkwB+L3C+9C6GxOuQSU19Y1VHoCQbgJzZBdo+
MSUlWbYYkwIsuidnH1APh+oNe9vR4ZNOgKHwzDK4WoFIhTHKJDYJ0w1nbl8B+lob
wgSRxArgZFXTCEx0XfBJ5qqvQgUH0+/tJMbEaAZoo7AqmzZ/Kr0zxmNAtolMU+v8
LJgOdyeGhFoNhOCSVmDVRTfbHQUMu+Coa1u9zJsjqwNoGtJcNf7ZUhMpcG4KeFUC
bQzbl/agpt6nxJ13e8eSyfmxHhoCmZQUXWCoTMahBD5opePU6GLm3U63uejxQBDl
n/ntlCh0iNxFs6TyrY9pJ1jC/nSFA0YTyutnhbN12GCA8oxVAvHTnPedKBKFLNi/
zlFw36UhEVyo8V8kCF4Un35kqiqTLmXU64q99HGBHNel3+yvzJuSQArxWdjGKoBM
JP6dbckx9MCcvn5kgEgavNQLH58g9Mr3u6DUExhtROfrcNhtHbGxaiI71bc9nsku
OjpnCFggSU95zhzlGrOpciwGLVVxtOKgwbtfvOxBBQ2BcmdKt3bjl2skcz/bOgjJ
GZhe6ynwZNsYZn/LDdYi8wyaAXD2ibsbOS7VID63kj8L2D9cCVVcoHcvvNGz2dnm
EOyLdbGzPf7vAe4QQH72kVF7NAzmETCVKo68bmY6VloKmdnQUYw=
=RScv
-----END PGP SIGNATURE-----

--liEBRWh70EtGAjVIOYSGFuEVZo24vk9Jk--
