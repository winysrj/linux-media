Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DGsQ0k024669
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 12:54:26 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7DGsCt3029204
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 12:54:13 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
	<1218621820.48a2b17c963cd@imp.free.fr>
	<Pine.LNX.4.64.0808131322340.3884@axis700.grange>
	<87skt86fb9.fsf@free.fr>
	<Pine.LNX.4.64.0808131845200.7458@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 13 Aug 2008 18:54:11 +0200
In-Reply-To: <Pine.LNX.4.64.0808131845200.7458@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed\,
	13 Aug 2008 18\:47\:48 +0200 \(CEST\)")
Message-ID: <87hc9o6eks.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: style cleanup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> > @@ -778,15 +776,13 @@ static int mt9m111_init(struct soc_camera_device *icd)
>> >  
>> >  	mt9m111->context = HIGHPOWER;
>> >  	ret = mt9m111_enable(icd);
>> > -	if (ret >= 0)
>> > +	if (!ret) {
>> >  		mt9m111_reset(icd);
>> > -	if (ret >= 0)
>> >  		mt9m111_set_context(icd, mt9m111->context);
>> > -	if (ret >= 0)
>> >  		mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
>> > -	if (ret < 0)
>> > +	} else
>> >  		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
>> > -	return ret ? -EIO : 0;
>> > +	return ret;
>> >  }
>> You changed the fault path here : you don't check if every call succeeds. I
>> don't think it's very important though ... I certainly don't care that much.
>
> Sorry, don't understand, you don't set "ret" in the above calls, so, I 
> don't think I changed anything.
That is because I'm a fool :)
The correct behaviour would be something like :

@@ -778,15 +776,13 @@ static int mt9m111_init(struct soc_camera_device *icd)
 
 	mt9m111->context = HIGHPOWER;
 	ret = mt9m111_enable(icd);
-	if (ret >= 0)
+	if (!ret)
 		ret = mt9m111_reset(icd);
-	if (ret >= 0)
+	if (!ret)
 		ret = mt9m111_set_context(icd, mt9m111->context);
-	if (ret >= 0)
+	if (!ret)
 		ret = mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
-	if (ret < 0)
+	if (ret)
 		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
-	return ret ? -EIO : 0;
+	return ret;
 }

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
